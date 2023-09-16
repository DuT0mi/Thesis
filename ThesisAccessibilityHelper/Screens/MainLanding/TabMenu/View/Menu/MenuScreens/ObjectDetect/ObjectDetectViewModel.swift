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

        cameraManagerInstance.$error
            .receive(on: RunLoop.main)
            .map { $0 } // CameraError -> Error
            .assign(to: &$error)

        cameraManagerInstance.$boundsSize
            .receive(on: RunLoop.main)
            .assign(to: &$bufferSize)

        cameraManagerInstance.$resultLabel
            .receive(on: RunLoop.main)
            .assign(to: &$resultLabel)
    }
}

// MARK: - ObjectDetectViewModelInput

extension ObjectDetectViewModel: ObjectDetectViewModelInput {
    func didAppear() {
        let noti = Notification(name: Notification.Name("VISIONNOW"))
        NotificationCenter.default.post(noti)
    }

    func didDisAppear() {
        tabHosterInstance.tabBarStatus.send(.show)
        cameraManagerInstance.stopSession()
    }
}
