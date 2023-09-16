//
//  FrameManager.swift
//  ThesisAccessibilityHelper
//
//  Created by Dudas Tamas Alex on 2023. 09. 16..
//

import AVFoundation

final class FrameManager: NSObject, ObservableObject {
    // MARK: - Properties

    @Published var current: CVPixelBuffer? // Received object from the camera

    private let videoQueue = DispatchQueue(label: "VideoQueue", qos: .userInitiated, attributes: [], autoreleaseFrequency: .workItem) // Output

    static let shared = FrameManager()

    // MARK: - Initialization

    private override init() {
        super.init()

        CameraManager.shared.set(self, queue: videoQueue)
    }
}

// MARK: - AVCaptureVideoDataOutputSampleBufferDelegate

extension FrameManager: AVCaptureVideoDataOutputSampleBufferDelegate {
    func captureOutput(
    _ output: AVCaptureOutput,
    didOutput sampleBuffer: CMSampleBuffer,
    from connection: AVCaptureConnection
    ) {
        if let buffer = sampleBuffer.imageBuffer {
            DispatchQueue.main.async {
                self.current = buffer
            }
        }
    }
}
