//
//  ObjectDetectView.swift
//  ThesisAccessibilityHelper
//
//  Created by Dudas Tamas Alex on 2023. 09. 16..
//

import SwiftUI

struct ObjectDetectView: View {
    // MARK: - Properties

    @StateObject private var viewModel = ObjectDetectViewModel()

    @State private var showAlert = false

    var body: some View {
        ZStack {
            CameraFrameView(image: viewModel.frame)
                .ignoresSafeArea()
            ObjectView(
                resultLabel: viewModel.capturedObject.capturedLabel,
                bufferSize: viewModel.capturedObject.capturedObjectBounds
            )
        }
        .alert(isPresented: $showAlert) {
            Alert(title: Text("Mutasd"), primaryButton: .destructive(Text("Olvasd fel"), action: {
                viewModel.speak(viewModel.capturedObject.capturedLabel) {
                    showAlert = false
                    viewModel.resumeSession()
                }
            }), secondaryButton: .cancel({
                showAlert = false
                viewModel.resumeSession()
            }))
        }
        .onChange(of: viewModel.capturedObject, perform: { _ in
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                viewModel.stopSession()
                showAlert = true
            }
        })
        .onDisappear {
            viewModel.didDisAppear()
        }
        .onAppear {
            viewModel.didAppear()
        }
    }
}

struct ObjectDetectView_Previews: PreviewProvider {
    static var previews: some View {
        ObjectDetectView()
    }
}
