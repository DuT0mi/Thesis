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

final class ObjectDetectViewModel: ObservableObject {
    // MARK: - Properties

    @Published var frame: CGImage? // Holds the current image
    @Published var error: Error?
    @Published var resultLabel: VNClassificationObservation?
    @Published var bufferSize: CGRect?

    private let tabHosterInstance = TabHosterViewViewModel.shared
    private let frameManagerInstance = FrameManager.shared
    private let cameraManagerInstance = CameraManager.shared

    private var cancellables = Set<AnyCancellable>()

    init() {
        subscriptions()
    }

    // MARK: - Functions

    private func subscriptions() {
        frameManagerInstance.$current
            .receive(on: RunLoop.main)
            .compactMap { CGImage.create(from: $0) } // CVPixelBuffer -> CGImage
            .assign(to: &$frame)

        frameManagerInstance.$currentImage
            .receive(on: RunLoop.main)
            .delay(for: .seconds(0.1), scheduler: RunLoop.main)
            .sink { uiImage in
                self.cropRectFromImage(image: uiImage, rect: self.bufferSize)
            }
            .store(in: &cancellables)

        cameraManagerInstance.$error
            .receive(on: RunLoop.main)
            .map { $0 } // CameraError -> Error
            .assign(to: &$error)

        cameraManagerInstance.$boundsSize
            .receive(on: RunLoop.main)
            .delay(for: .seconds(0.1), scheduler: RunLoop.main)
            .assign(to: &$bufferSize)

        cameraManagerInstance.$resultLabel
            .receive(on: RunLoop.main)
            .delay(for: .seconds(0.1), scheduler: RunLoop.main)
            .assign(to: &$resultLabel)
    }

    private func cropRectFromImage(image: UIImage?, rect: CGRect?) {
        guard let image, let rect, let cropped = cropImage(image, toRect: rect), let cgImage = cropped.cgImage else { return }

        let requestHandler = VNImageRequestHandler(cgImage: cgImage)

        let request = VNRecognizeTextRequest { request, error in
            guard let observations = request.results as? [VNRecognizedTextObservation], error == nil else {return}

             let topCandiateText = observations.compactMap {
                 $0.topCandidates(1).first?.string
             }.joined(separator: ", ")

            let boundingRects: [CGRect] = observations.compactMap { observation in

                // Find the top observation.
                guard let candidate = observation.topCandidates(1).first else { return .zero }

                // Find the bounding-box observation for the string range.
                let stringRange = candidate.string.startIndex..<candidate.string.endIndex
                let boxObservation = try? candidate.boundingBox(for: stringRange)

                // Get the normalized CGRect value.
                let boundingBox = boxObservation?.boundingBox ?? .zero

                // Convert the rectangle from normalized coordinates to image coordinates.
                return VNImageRectForNormalizedRect(boundingBox,
                                                    Int(image.size.width),
                                                    Int(image.size.height))
            }

            print("FOUND TEXT: \(topCandiateText) | AT RECT: \(boundingRects)")

        }

        request.recognitionLanguages = ["hu_HU"]
        request.recognitionLevel = VNRequestTextRecognitionLevel.accurate

        do {
            try requestHandler.perform([request])
        } catch {
            print(error)
        }

    }

    private func cropImage(_ image: UIImage, toRect rect: CGRect) -> UIImage? {
        let scale = image.scale
        let rectInPixels = CGRect(x: rect.origin.x * scale, y: rect.origin.y * scale, width: rect.size.width * scale, height: rect.size.height * scale)

        if let cgImage = image.cgImage?.cropping(to: rectInPixels) {
            return UIImage(cgImage: cgImage, scale: scale, orientation: image.imageOrientation)
        }

        return nil
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
