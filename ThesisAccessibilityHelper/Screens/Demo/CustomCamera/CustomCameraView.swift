//
//  CustomCameraVIew.swift
//  ThesisAccessibilityHelper
//
//  Created by Dudas Tamas Alex on 2023. 09. 10..
//

import SwiftUI
import AVFoundation

struct CustomCameraView: View {
    @StateObject private var viewModel = CameraViewModel()

    var body: some View {
        ZStack {

            // Going to be the camera's preview
            CameraPreview(cameraVM: viewModel)
                .ignoresSafeArea()

            VStack {
                if viewModel.isTaken {
                    HStack {
                        Spacer()

                        Button {
                            viewModel.reTake()
                        } label: {
                            Image(systemName: "arrow.triangle.2.circlepath.camera")
                                .foregroundColor(.black)
                                .background(Color.white)
                                .clipShape(Circle())
                        }
                        .padding(.trailing)
                    }
                }

                Spacer()

                HStack {
                    if viewModel.isTaken {
                        Button {
                            if !viewModel.isSaved {
                                viewModel.savePic()
                            }
                        } label: {
                            Text(viewModel.isSaved ? "Saved" : "Save")
                                .foregroundColor(.blue)
                                .fontWeight(.semibold)
                                .padding()
                                .background(Color.white)
                                .clipShape(Capsule())
                        }
                        .padding(.leading)

                        Spacer()
                    } else {
                        Button {
                            viewModel.takePic()
                        } label: {
                            ZStack {
                                Circle()
                                    .fill(Color.white)
                                    .frame(width: 65, height: 65)
                                Circle()
                                    .stroke(Color.white, lineWidth: 2)
                                    .frame(width: 75, height: 75)
                            }
                        }
                    }
                }
                .frame(height: 75)
            }
        }
        .onAppear {
            viewModel.check()
        }
    }
}

// VM

class CameraViewModel: NSObject, ObservableObject, AVCapturePhotoCaptureDelegate {
    @Published var isTaken = false

    @Published var session = AVCaptureSession()

    @Published var alert = false

    @Published var output = AVCapturePhotoOutput()

    @Published var previewLayer: AVCaptureVideoPreviewLayer!

    @Published var isSaved = false

    @Published var picData = Data(count: 0)

    func check() {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
            case .authorized:
                setup()
            case .notDetermined:
                AVCaptureDevice.requestAccess(for: .video) { status in
                    if status {
                        self.setup()
                    }
                }
            case .denied:
                self.alert.toggle()
            default:
                return
        }
    }
    func setup() {
        do {
            session.beginConfiguration()

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

    func takePic() {
        DispatchQueue.global(qos: .background).async {
            self.output.capturePhoto(with: AVCapturePhotoSettings(), delegate: self)

            DispatchQueue.main.async {
                withAnimation {
                    self.isTaken.toggle()
                }
            }

            self.session.stopRunning()
        }
    }

    func reTake() {
        DispatchQueue.global(qos: .background).async {
            self.session.startRunning()

            DispatchQueue.main.async {
                withAnimation {
                    self.isTaken.toggle()
                    self.isSaved = false
                }
            }
        }
    }

    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        if error != nil {
            return
        }

        guard let imageData = photo.fileDataRepresentation() else { return }

        self.picData = imageData
    }

    func savePic() {
        let image = UIImage(data: self.picData)!

        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)

        self.isSaved = true
    }

}

struct CameraPreview: UIViewRepresentable {
    func updateUIView(_ uiView: UIViewType, context: Context) {
    }

    @ObservedObject var cameraVM: CameraViewModel

    func makeUIView(context: Context) -> some UIView {
        let view = UIView(frame: UIScreen.main.bounds)

        cameraVM.previewLayer = AVCaptureVideoPreviewLayer(session: cameraVM.session)
        cameraVM.previewLayer.frame = view.frame
        cameraVM.previewLayer.videoGravity = .resizeAspectFill

        view.layer.addSublayer(cameraVM.previewLayer)

        cameraVM.session.startRunning()

        return view
    }
}


struct CustomCameraView_Previews: PreviewProvider {
    static var previews: some View {
        CustomCameraView()
    }
}
