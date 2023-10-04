//
//  ScanDocumentView.swift
//  ThesisAccessibilityHelper
//
//  Created by Dudas Tamas Alex on 2023. 09. 24..
//

import SwiftUI

struct ScanDocumentView: View {
    // MARK: - Types

    private struct Consts {
        static let showCaseLight = Color.yellow
        static let showCaseDark = Color.yellow
        static let imageTintLight = Color.black
        static let imageTintDark = Color.white
    }

    // MARK: - Properties

    @Environment(\.colorScheme) private var colorScheme
    @Environment(\.managedObjectContext) private var managedObjectContext

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
            if !viewModel.isSpeakerSpeaks {
                VStack {
                    HintView()
                        .onTapGesture {
                            didTapHint = true
                        }
                    if !viewModel.isLoading, !viewModel.models.isEmpty {
                        ImagesCarousel(images: mockImages())
                            .frame(width: 250, height: 250)
                            .padding(.top)
                    } else {
                        ContentUnavailableView {
                            Label("You haven't scanned yet", systemImage: "camera.metering.unknown")
                        } description: {
                            Text("Try it out!")
                        } actions: {
                            Button("Scan", systemImage: "camera.metering.unknown") {
                                self.showCamera.toggle()
                            }
                            .buttonBorderShape(.capsule)
                            .buttonStyle(.borderedProminent)
                            .tint(Color.white)
                            .foregroundStyle(.black)
                        }
                        .frame(width: 250, height: 250)

                    }
                }
            } else {
                ProgressView()
            }

        }
        .sheet(isPresented: $showCamera) {
            DocumentPickerView {
                showCamera.toggle()
            } didFinish: { recognizedModel in
                viewModel.appendElements(recognizedModel, on: managedObjectContext)
                viewModel.start()
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
                ZStack {
                    Circle()
                        .fill(colorScheme == .dark ? Consts.showCaseDark : Consts.showCaseLight)
                        .frame(width: 35, height: 35)
                        .opacity(self.opacityOfShowCase)
                    Image(systemName: "doc.viewfinder")
                        .tint(colorScheme == .dark ? Consts.imageTintDark : Consts.imageTintLight)
                        .bold()
                        .onTapGesture {
                            showCamera.toggle()
                        }
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

    private func mockImages() -> [Image] {
        [
            Image(.mockImage0),
            Image(.mockImage1),
            Image(.mockImage2),
            Image(.mockImage3),
            Image(.mockImage4)
        ]
    }
}

#Preview {
    NavigationStack {
        ScanDocumentView()
    }
}
