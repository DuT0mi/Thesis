//
//  CameraManager.swift
//  ThesisAccessibilityHelper
//
//  Created by Dudas Tamas Alex on 2023. 09. 16..
//

import AVFoundation
import UIKit
import Vision

final class CameraManager: BaseCameraManager {
    // MARK: - Types
    
    /// Represent a captured object
    /// - Parameters:
    ///   - capturedLabel: The captured object's label with the highes confidence
    ///   - capturedObjectBounds: The captured object's position and size
    struct CameraResultModel {
        var capturedLabel: String
        var capturedObjectBounds: CGRect
    }

    static var defaultCameraResultModel: CameraResultModel = {
        CameraResultModel(capturedLabel: "", capturedObjectBounds: .zero)
    }()

    private struct Consts {
        static let model = (name: "YOLOv3Tiny", fileExtension: "mlmodelc")
    }

    // MARK: - Properties

//    @Published var resultLabel: VNClassificationObservation?
//    @Published var boundsSize: CGRect?

    @Published var capturedObject: CameraResultModel =  .init(capturedLabel: "", capturedObjectBounds: .zero) {
        willSet {
            objectWillChange.send()
        }
    }

    // Vision parts
    @Published var requests = [VNRequest]()

    static let shared = CameraManager()

    private var bufferSize: CGSize = .zero

    // MARK: - Initialization

    override init() {
        super.init()

        addObservers()
    }

    // MARK: - BaseCameraManager functions

    override func configure() {
        super.configure()

        sessionQueue.async {
            self.setupSession()
            self.setupVision()
            self.startSession()
        }
    }

    // swiftlint:disable force_unwrapping
    /// ``BaseCameraManager`` functions,  next to the session initalization also configures the `bufferSize` to the actual size.
    override func setupSession() {
        super.setupSession()

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

    // MARK: - Functions

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
                        if result.count != .zero {
                            self.handleResults(result)
                        }
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

            capturedObject = .init(capturedLabel: topLabelObservation.identifier, capturedObjectBounds: objectBounds)

//            resultLabel = topLabelObservation
//            boundsSize = objectBounds
        }
    }

    private func update() {
        objectWillChange.send()
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
