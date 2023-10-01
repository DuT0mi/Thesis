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
    @State private var opacityOfShowCase: Double = .zero
    @State private var didTapHint = false {
        didSet {
            guard didTapHint else { return }
            updateHintFlag()
        }
    }

    @State private var showCamera = false

    var body: some View {
        BaseView {
            ZStack {
                if !viewModel.isSpeakerSpeaks {
                    HintView()
                        .onTapGesture {
                            didTapHint = true
                        }
                } else {
                    ProgressView()
                }
            }
        }
        .sheet(isPresented: $showCamera) {
            DocumentPickerView {
                showCamera.toggle()
            } didFinish: { recognizedModel in
                recognizedModel.forEach { viewModel.speak($0.resultingText)}
            }
            .sheetStyle(style: .mixed, dismissable: true, showIndicator: true)

        }
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                withAnimation(.bouncy) {
                    Image(systemName: "stop")
                        .bold()
                        .onTapGesture {
                            viewModel.stop()
                        }
                        .padding(.trailing)
#if !targetEnvironment(simulator)
                        .opacity(viewModel.isSpeakerSpeaks ? 1 : 0)
#endif
                }
            }

            ToolbarItem(placement: .topBarTrailing) {
                Image(systemName: "doc.viewfinder")
                    .bold()
                    .onTapGesture {
                        showCamera.toggle()
                    }
                    .overlay {
                        Circle()
                            .fill(Color.red.opacity(0.2))
                            .frame(width: 35, height: 35)
                            .opacity(self.opacityOfShowCase)
                    }
            }
        }
        .ignoresSafeArea()
    }

    // MARK: - Functions

    private func updateHintFlag() {
        withAnimation(.easeInOut(duration: 2.0)) {
            self.opacityOfShowCase = self.opacityOfShowCase == .zero ? 1 : .zero
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0 + 1.5) {
            withAnimation(.interpolatingSpring(duration: 0.7)) {
                self.opacityOfShowCase = .zero
            }
        }
    }
}

#Preview {
    NavigationStack {
        ScanDocumentView()
    }
}
