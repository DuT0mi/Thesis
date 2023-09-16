//
//  ObjectDetectViewModel.swift
//  ThesisAccessibilityHelper
//
//  Created by Dudas Tamas Alex on 2023. 09. 16..
//

import Foundation
import CoreImage

protocol ObjectDetectViewModelInput: BaseViewModelInput {
}

final class ObjectDetectViewModel: ObservableObject {
    // MARK: - Properties

    @Published var frame: CGImage? // Holds the current image
    @Published var error: Error?

    private let tabHosterInstance = TabHosterViewViewModel.shared
    private let frameManagerInstance = FrameManager.shared
    private let cameraManagerInstance = CameraManager.shared

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
    }

}

// MARK: - ObjectDetectViewModelInput

extension ObjectDetectViewModel: ObjectDetectViewModelInput {
    func didAppear() {
    }

    func didDisAppear() {
        tabHosterInstance.tabBarStatus.send(.show)
    }
}
