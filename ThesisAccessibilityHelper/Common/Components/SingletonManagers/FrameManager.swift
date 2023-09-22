//
//  FrameManager.swift
//  ThesisAccessibilityHelper
//
//  Created by Dudas Tamas Alex on 2023. 09. 16..
//

import AVFoundation
import Vision
import UIKit

final class FrameManager: NSObject, ObservableObject {
    // MARK: - Properties

    /// The current frame from the device
    @Published var current: CVPixelBuffer?

    /// Output and its queue
    private let videoQueue = DispatchQueue(label: "VideoQueue", qos: .userInitiated, attributes: [], autoreleaseFrequency: .workItem)

    static let shared = FrameManager()

    // MARK: - Initialization

    private override init() {
        super.init()

        CameraManager.shared.set(self, queue: videoQueue)
    }
}

// MARK: - AVCaptureVideoDataOutputSampleBufferDelegate

extension FrameManager: AVCaptureVideoDataOutputSampleBufferDelegate {
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        if let buffer = sampleBuffer.imageBuffer {
            DispatchQueue.main.async {
                self.current = buffer
            }
        }

        guard let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else {
            return
        }

        let exifOrientation = exifOrientationFromDeviceOrientation()

        let imageRequestHandler = VNImageRequestHandler(cvPixelBuffer: pixelBuffer, orientation: exifOrientation, options: [:])

        do {
            try imageRequestHandler.perform(CameraManager.shared.requests)
        } catch {
            print(error)
        }
    }
}

// MARK: - FrameManager

extension FrameManager {
    /// Returns the current orientation of the device
    /// - Returns:
    ///   - __CGImagePropertyOrientation__
    func exifOrientationFromDeviceOrientation() -> CGImagePropertyOrientation {
        let curDeviceOrientation = UIDevice.current.orientation
        let exifOrientation: CGImagePropertyOrientation

        switch curDeviceOrientation {
            case UIDeviceOrientation.portraitUpsideDown:  // Device oriented vertically, home button on the top
                exifOrientation = .left
            case UIDeviceOrientation.landscapeLeft:       // Device oriented horizontally, home button on the right
                exifOrientation = .upMirrored
            case UIDeviceOrientation.landscapeRight:      // Device oriented horizontally, home button on the left
                exifOrientation = .down
            case UIDeviceOrientation.portrait:            // Device oriented vertically, home button on the bottom
                exifOrientation = .up
            default:
                exifOrientation = .up
        }
        return exifOrientation
    }
}
