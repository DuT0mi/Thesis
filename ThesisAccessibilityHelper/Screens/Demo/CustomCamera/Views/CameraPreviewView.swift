//
//  CameraPreviewView.swift
//  ThesisAccessibilityHelper
//
//  Created by Dudas Tamas Alex on 2023. 09. 10..
//

import Foundation
import AVFoundation
import SwiftUI

struct CameraPreview: UIViewRepresentable {
    @ObservedObject var viewModel: CameraViewModel

    func makeUIView(context: Context) -> some UIView {
        let view = UIView(frame: UIScreen.main.bounds)

        let previewLayer = AVCaptureVideoPreviewLayer(session: viewModel.session)
        previewLayer.frame = view.frame
        previewLayer.videoGravity = .resizeAspectFill

        view.layer.addSublayer(previewLayer)

        DispatchQueue.global(qos: .userInitiated).async {
            viewModel.session.startRunning()
        }

        return view
    }

    func updateUIView(_ uiView: UIViewType, context: Context) {

    }
}
