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
import Resolver

protocol ObjectDetectViewModelInput: BaseViewModelInput {
}

@MainActor
final class ObjectDetectViewModel: ObservableObject {
    // MARK: - Types

    enum HapticType {
        case impact
        case notification
    }

    // MARK: - Properties

    /// Holds the current Image as `CGImage`
    @Published var frame: CGImage?
    @Published var error: Error?

    @Published var capturedObject: CameraManager.CameraResultModel

    var refreshTime: Int {
        tabProfileVM.objectDetectRefreshData
    }

    @Injected private var hapticManager: HapticManager
    @Injected private var tabHosterInstance: TabHosterViewViewModel
    @Injected private var frameManagerInstance: FrameManager
    @Injected private var cameraManagerInstance: CameraManager
    @Injected private var speaker: SynthesizerManager
    @Injected private var tabProfileVM: TabProfileLandingViewModel

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

    func resetModelToForceUpdateView() {
        capturedObject = .init(capturedLabel: String(), capturedObjectBounds: .zero)
    }

    func showHaptic(type: HapticType, impactStyle: UIImpactFeedbackGenerator.FeedbackStyle = .heavy, notificationStyle: UINotificationFeedbackGenerator.FeedbackType = .success) {
        switch type {
            case .impact:
                hapticManager.impactGenerator(style: impactStyle)
            case .notification:
                hapticManager.notificationGenerator(type: notificationStyle)
        }
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
        let noti = Notification(name: .visionWillAppear)
        NotificationCenter.default.post(noti)
    }

    func didDisAppear() {
        tabHosterInstance.tabBarStatus.send(.show)
        cameraManagerInstance.stopSession()
    }
}
