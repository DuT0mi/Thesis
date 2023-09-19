//
//  BaseCameraManager.swift
//  ThesisAccessibilityHelper
//
//  Created by Dudas Tamas Alex on 2023. 09. 19..
//

import Foundation
import AVFoundation

/// Represent a Base class to all of the Camera ViewModels
class BaseCameraManager: NSObject, ObservableObject {
    // MARK: - Types

    enum Status {
        case unconfigured
        case configured
        case unauthorized
        case failed
    }

    // MARK: - Properties

    @Published var error: CameraError?

    let session = AVCaptureSession()

    let sessionQueue = DispatchQueue(label: "SessionQueue", qos: .userInitiated, attributes: [], autoreleaseFrequency: .workItem)

    let videoOutput = AVCaptureVideoDataOutput()

    var status: Status = .unconfigured

    // MARK: - Initialization

    override init() {
        super.init()

        configure()
    }
    // MARK: - Functions

    /// Getting called with the `init`, handling the permissions
    func configure() {
        checkPermission()
    }

    /// Starts the `AVCaptureSession`
    func stopSession() {
        guard session.isRunning else { return }

        session.stopRunning()
    }

    /// Stops the `AVCaptureSession`
    func startSession() {
        guard !session.isRunning else { return }

        session.startRunning()
    }

    /// Setups the `AVCaptureSession`, **must be overwritten in the subclass**
    func setupSession() {
    }

    /// Setting the error manually
    ///  - Parameters:
    ///    - error: The error which is will be set, `must` be a ``CameraError``
    func set(error: Error) {
        guard let error = error as? CameraError else { return }

        DispatchQueue.main.async {
            self.error = error
        }
    }

    /// Handles the permissions
    private func checkPermission() {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
            case .notDetermined:
                sessionQueue.suspend()

                AVCaptureDevice.requestAccess(for: .video) { didGet in
                    guard didGet else {
                        self.status = .unauthorized
                        self.set(error: CameraError.deniedAuthorization)

                        return
                    }
                    self.sessionQueue.resume()
                }

            case .authorized:
                break

            case .denied:
                status = .unauthorized
                set(error: CameraError.deniedAuthorization)

            case .restricted:
                status = .unauthorized
                set(error: CameraError.restrictedAuthorization)

            @unknown default:
                status = .unauthorized
                set(error: CameraError.unknownAuthorization)
        }
    }
}
