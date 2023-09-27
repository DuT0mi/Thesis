//
//  ScanDocumentView.swift
//  ThesisAccessibilityHelper
//
//  Created by Dudas Tamas Alex on 2023. 09. 24..
//

import SwiftUI

struct ScanDocumentView: View {
    // MARK: - Properties

    @StateObject private var viewModel = ScanDocumentViewModel()

    @State private var showLoading = false
    @State private var showCamera = false

    var body: some View {
        BaseView {
            VStack {
                Group {
                    Button("Scan") {
                        showCamera.toggle()
                    }

                    Button("Stop speaking") {
                        viewModel.stop()
                    }
                    .opacity(viewModel.isSpeakerSpeaks ? 1 : 0)
                }
                .padding()
            }
            if showLoading || viewModel.isSpeakerSpeaks {
                ProgressView()
            }

        }
        .sheet(isPresented: $showCamera) {
            DocumentPickerView {
                showLoading.toggle()
                showCamera.toggle()
            } didFinish: { recognizedText in
                viewModel.speak(recognizedText)
                showLoading.toggle()
            }
            .sheetStyle(style: .large, dismissable: true, showIndicator: true)

        }
        .ignoresSafeArea()
    }
}

#Preview {
    ScanDocumentView()
}
