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

    @State private var showCamera = false

    var body: some View {
        BaseView {
            VStack {
                Spacer()
                Button("Scan") {
                    showCamera.toggle()
                }

                Spacer()
                Button("Stop speaking") {
                    viewModel.stop()
                }
#if !targetEnvironment(simulator)
                .opacity(viewModel.isSpeakerSpeaks ? 1 : 0)
#endif
                Spacer()
            }
            if viewModel.isSpeakerSpeaks {
                ProgressView()
            }

        }
        .sheet(isPresented: $showCamera) {
            DocumentPickerView {
                showCamera.toggle()
            } didFinish: { recognizedModel in
                recognizedModel.forEach { viewModel.speak($0.resultingText)}
            }
            .sheetStyle(style: .large, dismissable: true, showIndicator: true)

        }
        .ignoresSafeArea()
    }
}

#Preview {
    ScanDocumentView()
}
