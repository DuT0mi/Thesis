//
//  CustomCameraViewModel.swift
//  ThesisAccessibilityHelper
//
//  Created by Dudas Tamas Alex on 2023. 09. 10..
//

import Foundation
import AVFoundation
import UIKit
import SwiftUI

protocol CameraViewModelInput {
    func didAppear(_ environmentObject: any ObservableObject)
    func didDidDisappear()
}

final class CameraViewModel: NSObject, ObservableObject {
    // MARK: - Properties

    @Published var isTaken = false

    @Published var session = AVCaptureSession()

    @Published var alert = false

    @Published var output = AVCapturePhotoOutput()

    @Published var previewLayer: AVCaptureVideoPreviewLayer!

    @Published var isSaved = false

    @Published var picData = Data(count: 0)

    private var cachedViewModel: (any ObservableObject)?

    // MARK: - Functions

    func takePicture() {
#if !targetEnvironment(simulator)// swiftlint:disable indentation_width
        DispatchQueue.global(qos: .background).async {
            self.output.capturePhoto(with: AVCapturePhotoSettings(), delegate: self)

            DispatchQueue.main.async {
                withAnimation {
                    self.isTaken.toggle()
                }
            }

            self.session.stopRunning()
        }
#else
        isTaken.toggle()
#endif // swiftlint:enable indentation_width
    }

    func reTakePicture() {
#if !targetEnvironment(simulator)// swiftlint:disable indentation_width
        DispatchQueue.global(qos: .background).async {
            self.session.startRunning()

            DispatchQueue.main.async {
                withAnimation {
                    self.isTaken.toggle()
                    self.isSaved = false
                }
            }
        }
#else
        self.isTaken.toggle()
        self.isSaved = false
#endif // swiftlint:enable indentation_width
    }

    func savePicture() {
#if !targetEnvironment(simulator)// swiftlint:disable indentation_width
        if let image = UIImage(data: self.picData) {
            UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
        } else {
            fatalError("Give alert or etc | IMAGE DATA IS NIL")
        }
#endif
        self.isSaved = true // swiftlint:enable indentation_width
    }

    private func checkAuthorization() {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
            case .authorized:
                setupConfiguration()
            case .notDetermined:
                AVCaptureDevice.requestAccess(for: .video) { status in
                    if status {
                        self.setupConfiguration()
                    }
                }
            case .denied:
                self.alert.toggle()
            default:
                return
        }
    }

    private func setupConfiguration() {
        do {
            session.beginConfiguration()

            // Depends on the device
            let device = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back)

            let input = try AVCaptureDeviceInput(device: device!)

            if self.session.canAddInput(input) {
                self.session.addInput(input)
            }

            if self.session.canAddOutput(self.output) {
                self.session.addOutput(self.output)
            }

            self.session.commitConfiguration()

        } catch {
            print(error.localizedDescription)
        }
    }
}

// MARK: - CameraViewModelInput

extension CameraViewModel: CameraViewModelInput {
    func didAppear(_ environmentObject: any ObservableObject) {
        if let landingInstance = environmentObject as? LandingViewModel {
            cachedViewModel = landingInstance
            landingInstance.tabBarStatus.send(.hide)
        }
        checkAuthorization()
    }

    func didDidDisappear() {
        if let landingVM = cachedViewModel as? LandingViewModel {
            landingVM.tabBarStatus.send(.show)
        }
    }
}

// MARK: - AVCapturePhotoCaptureDelegate

extension CameraViewModel: AVCapturePhotoCaptureDelegate {
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        if error != nil {
            return
        }

        guard let imageData = photo.fileDataRepresentation() else { return }

        self.picData = imageData
    }
}
