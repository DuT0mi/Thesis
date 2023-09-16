//
//  CameraManager.swift
//  ThesisAccessibilityHelper
//
//  Created by Dudas Tamas Alex on 2023. 09. 16..
//

import AVFoundation

final class CameraManager: NSObject, ObservableObject {
    // MARK: - Types

    enum Status {
        case unconfigured
        case configured
        case unauthorized
        case failed
    }

    // MARK: - Properties

    @Published var error: CameraError?

    static let shared = CameraManager()

    let session = AVCaptureSession()

    var bufferSize: CGSize = .zero

    private let sessionQueue = DispatchQueue(label: "SessionQueue", qos: .userInitiated, attributes: [], autoreleaseFrequency: .workItem)

    private let videoOutput = AVCaptureVideoDataOutput()

    private var status: Status = .unconfigured

    // MARK: - Initialization

    private override init() {
        super.init()

        configure()
    }

    // MARK: - Functions

    private func configure() {
        checkPermission()

        sessionQueue.async {
            self.setupSession()
            self.session.startRunning()
        }
    }

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

    // swiftlint:disable force_unwrapping
    private func setupSession() {
        guard status == .unconfigured else { return }

        var deviceInput: AVCaptureDeviceInput!

        session.beginConfiguration()

        defer { session.commitConfiguration() }

        let device = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInWideAngleCamera], mediaType: .video, position: .back).devices.first

        do {
            deviceInput = try AVCaptureDeviceInput(device: device!)
        } catch {
            print("Could not add device: \(error.localizedDescription)")
            status = .failed
            set(error: CameraError.cameraUnavailable)

            return
        }

        session.sessionPreset = .vga640x480

        if session.canAddInput(deviceInput) {
            session.addInput(deviceInput)
        } else {
            status = .failed
            set(error: CameraError.cannotAddInput)

            return
        }

        if session.canAddOutput(videoOutput) {
            session.addOutput(videoOutput)

            videoOutput.alwaysDiscardsLateVideoFrames = true
            videoOutput.videoSettings = [kCVPixelBufferPixelFormatTypeKey as String: Int(kCVPixelFormatType_420YpCbCr8BiPlanarFullRange)]

            let connection = videoOutput.connection(with: .video)
            connection?.isEnabled = true

            do {
                try device!.lockForConfiguration()
                let dimension = CMVideoFormatDescriptionGetDimensions((device!.activeFormat.formatDescription))

                bufferSize.width = CGFloat(dimension.width)
                bufferSize.height = CGFloat(dimension.height)

                device!.unlockForConfiguration()
            } catch {

            }

        } else {
            status = .failed
            set(error: CameraError.cannotAddOutput)

            return
        }

        status = .configured
    }
    // swiftlint:enable force_unwrapping

    private func set(error: Error) {
        guard let error = error as? CameraError else { return }

        DispatchQueue.main.async {
            self.error = error
        }
    }
}

// MARK: - AVCaptureVideoDataOutputSampleBufferDelegate

extension CameraManager: AVCaptureVideoDataOutputSampleBufferDelegate {
    func set(_ delegate: AVCaptureVideoDataOutputSampleBufferDelegate, queue: DispatchQueue) {
        sessionQueue.async {
            self.videoOutput.setSampleBufferDelegate(delegate, queue: queue)
        }
    }
}
