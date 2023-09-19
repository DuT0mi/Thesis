//
//  CameraManager.swift
//  ThesisAccessibilityHelper
//
//  Created by Dudas Tamas Alex on 2023. 09. 16..
//

import AVFoundation
import UIKit
import Vision

final class CameraManager: NSObject, ObservableObject {
    // MARK: - Types

    enum Status {
        case unconfigured
        case configured
        case unauthorized
        case failed
    }

    private struct Consts {
        static let model = (name: "YOLOv3Tiny", fileExtension: "mlmodelc")
    }

    // MARK: - Properties

    @Published var error: CameraError?

    @Published var resultLabel: VNClassificationObservation?
    @Published var boundsSize: CGRect?

    // Vision parts
    @Published var requests = [VNRequest]()

    var bufferSize: CGSize = .zero

    static let shared = CameraManager()

    private let session = AVCaptureSession()

    private let sessionQueue = DispatchQueue(label: "SessionQueue", qos: .userInitiated, attributes: [], autoreleaseFrequency: .workItem)

    private let videoOutput = AVCaptureVideoDataOutput()

    private var status: Status = .unconfigured

    // MARK: - Initialization

    private override init() {
        super.init()

        addObservers()
        configure()
    }

    // MARK: - Functions

    func stopSession() {
        if session.isRunning {
            session.stopRunning()
        }
    }

    private func addObservers() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(visiounShouldConfigure),
            name: Notification.Name("VISIONNOW"),
            object: nil
        )
    }

    @objc private func visiounShouldConfigure() {
        configure()
    }

    private func configure() {
        checkPermission()

        sessionQueue.async {
            self.setupSession()
            self.setupVision()
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

        session.sessionPreset = .vga640x480 // model is 480 x 480

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
            connection?.videoOrientation = .portrait
            connection?.isVideoMirrored = true

            do {
                try device!.lockForConfiguration()
                let dimension = CMVideoFormatDescriptionGetDimensions((device!.activeFormat.formatDescription))

                bufferSize.width = CGFloat(dimension.width)
                bufferSize.height = CGFloat(dimension.height)

                device!.unlockForConfiguration()
            } catch {
                print(error)
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

    @discardableResult
    private func setupVision() -> NSError? {
        var error: NSError?

        guard let modelURL = Bundle.main.url(forResource: Consts.model.name, withExtension: Consts.model.fileExtension) else {
            return NSError(domain: "\(#file)", code: -1, userInfo: [NSLocalizedDescriptionKey: "Model file is missing!"])
        }

        do {
            let visionModel = try VNCoreMLModel(for: .init(contentsOf: modelURL))
            let objectRecognition = VNCoreMLRequest(model: visionModel) { request, capturedError in
                DispatchQueue.main.async {
                    if let result = request.results {
                        self.handleResults(result)
                    } else {
                        error = (capturedError as? NSError)
                    }
                }
            }
            self.requests = [objectRecognition]
        } catch let error as NSError {
            print("ERROR: \(String(describing: error.localizedDescription)) | AT: \(#file),\(#function), \(#line)")
        }

        return error
    }

    private func handleResults(_ results: [Any]) {
        for observation in results where observation is VNRecognizedObjectObservation {
            guard let objectObservation = observation as? VNRecognizedObjectObservation else {
                continue
            }
            // Select only the label with the highest confidence.
            let topLabelObservation = objectObservation.labels[0]
            let objectBounds = VNImageRectForNormalizedRect(objectObservation.boundingBox, Int(bufferSize.width), Int(bufferSize.height))

            resultLabel = topLabelObservation
            boundsSize = objectBounds
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
