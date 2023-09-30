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

    private let tabHosterInstance = TabHosterViewViewModel.shared
    private let frameManagerInstance = FrameManager.shared
    private let cameraManagerInstance = CameraManager.shared
    private let speaker = SynthesizerManager.shared

    private var cancellables = Set<AnyCancellable>()

    // MARK: - Initialization

    init() {
        _capturedObject = .init(initialValue: CameraManager.defaultCameraResultModel)

        subscriptions()
    }

    // MARK: - Functions

    func stopSession() {
        cameraManagerInstance.stopSession()
    }

    func resumeSession() {
        cameraManagerInstance.startSession()
    }

    private func subscriptions() {
        frameManagerInstance.$current
            .receive(on: RunLoop.main)
            .compactMap { CGImage.create(from: $0) } // CVPixelBuffer -> CGImage
            .assign(to: &$frame)

        cameraManagerInstance.$capturedObject
            .receive(on: RunLoop.main)
            .assign(to: &$capturedObject)

        cameraManagerInstance.$error
            .receive(on: RunLoop.main)
            .map { $0 } // CameraError -> Error
            .assign(to: &$error)
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
