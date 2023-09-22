//
//  ObjectDetectViewModel.swift
//  ThesisAccessibilityHelper
//
//  Created by Dudas Tamas Alex on 2023. 09. 16..
//

import Foundation
import CoreImage
import Vision
import Combine
import UIKit

protocol ObjectDetectViewModelInput: BaseViewModelInput {
}

@MainActor
final class ObjectDetectViewModel: ObservableObject {
    // MARK: - Properties

    @Published var frame: CGImage? // Holds the current image
    @Published var error: Error?

    @Published var capturedObject: CameraManager.CameraResultModel
    @Published var shouldUpdateView = false

    private let tabHosterInstance = TabHosterViewViewModel.shared
    private let frameManagerInstance = FrameManager.shared
    private let cameraManagerInstance = CameraManager.shared
    private let textRecognizerInstance = TextRecognizerManager.shared
    private let speaker = SynthesizerManager.shared

    private var cancellables = Set<AnyCancellable>()

    // MARK: - Initialization

    init() {
        _capturedObject = .init(initialValue: CameraManager.defaultCameraResultModel)

        subscriptions()
    }

    // MARK: - Functions

    private func subscriptions() {
        frameManagerInstance.$current
            .receive(on: RunLoop.main)
            .compactMap { CGImage.create(from: $0) } // CVPixelBuffer -> CGImage
            .assign(to: &$frame)

        cameraManagerInstance.$capturedObject
            .receive(on: RunLoop.main)
            .sink { [weak self] object in
                guard let frame = self?.frame,
                      let image = self?.cropImage(
                        UIImage(cgImage: frame),
                        toRect: object.capturedObjectBounds,
                        viewWidth: object.capturedObjectBounds.width,
                        viewHeight: object.capturedObjectBounds.height
                      )?.withHorizontallyFlippedOrientation() else { return }

                self?.textRecognizerInstance.recognize(image) { [weak self] result in

                    switch result {
                        case .success(let text):
                            guard !text.isEmpty else { return }
                            self?.speaker.speak(with: "TALÁLT SZÖVEG \(text)")
                        case .failure(let error):
                            print("ERROR AT: \(#fileID) | \(#function) | ERROR: \(error)")

                            return
                    }
                }
                self?.capturedObject = object

            }
            .store(in: &cancellables)

        cameraManagerInstance.$error
            .receive(on: RunLoop.main)
            .map { $0 } // CameraError -> Error
            .assign(to: &$error)
    }

    private func cropImage(_ inputImage: UIImage, toRect cropRect: CGRect, viewWidth: CGFloat, viewHeight: CGFloat) -> UIImage? {
        let cropZone = CGRect(x: cropRect.origin.x, y: cropRect.origin.y, width: cropRect.size.width, height: cropRect.size.height)

        guard let cutImageRef: CGImage = inputImage.cgImage?.cropping(to: cropZone)
        else {
            return nil
        }

        let croppedImage = UIImage(cgImage: cutImageRef)
        return croppedImage
    }
}

// MARK: - ObjectDetectViewModelInput

extension ObjectDetectViewModel: ObjectDetectViewModelInput {
    func didAppear() {
        let noti = Notification(name: Notification.Name("VISIONNOW")) // TODO: extend noti name
        NotificationCenter.default.post(noti)
    }

    func didDisAppear() {
        tabHosterInstance.tabBarStatus.send(.show)
        cameraManagerInstance.stopSession()
    }
}
