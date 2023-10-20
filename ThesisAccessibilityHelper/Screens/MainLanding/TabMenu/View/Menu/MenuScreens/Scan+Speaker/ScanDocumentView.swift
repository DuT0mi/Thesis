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

        struct Layout {
            static let contentFrameSize: CGFloat = 250

            static let toolbarItemFrameSize: CGFloat = 35 // min 28x28 <- HIG

            static let padding: CGFloat = 20
        }

        struct Appearance {
            static let imageFont: CGFloat = 20
        }

        struct Animation {
            static let baseTime: TimeInterval = 2.0
            static let extraTime: TimeInterval = 1.5
        }
    }

    // MARK: - Properties

    @Environment(\.colorScheme) private var colorScheme
    @Environment(\.managedObjectContext) private var managedObjectContext
    @FetchRequest(sortDescriptors: [SortDescriptor(\.imageId)]) var coreDataElements: FetchedResults<LocalData>

    @StateObject private var viewModel = ScanDocumentViewModel()

    @State private var opacityOfShowCase: Double = .zero
    @State private var didTapHint = false {
        didSet {
            guard didTapHint else { return }
            updateHintFlag()
        }
    }

    @State private var showCamera = false
    @State private var showAlert = false

    var body: some View {
        BaseView {
            if !viewModel.isSpeakerSpeaks {
                VStack {
                    HintView()
                        .onTapGesture {
                            didTapHint = true
                        }
                        .padding(.top, Consts.Layout.padding)
                    if !viewModel.isLoading, !viewModel.models.isEmpty, coreDataElements.count != .zero {
                        ImagesCarousel(models: viewModel.modelMapper(from: coreDataElements))
                            .frame(width: Consts.Layout.contentFrameSize, height: Consts.Layout.contentFrameSize)
                            .padding(.top)
                    } else if !viewModel.isLoading, viewModel.models.isEmpty, coreDataElements.count != .zero {
                        Label("Korábbi képeid, amelyek műveletre várnak.", image: "exclamationmark.bubble.fill")
                            .tint(Color.red)
                            .font(.system(size: Consts.Appearance.imageFont, weight: .bold, design: .rounded))
                        ImagesCarousel(models: viewModel.modelMapper(from: coreDataElements))
                            .frame(width: Consts.Layout.contentFrameSize, height: Consts.Layout.contentFrameSize )
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
                        .frame(width: Consts.Layout.contentFrameSize, height: Consts.Layout.contentFrameSize)

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
                        .opacity(viewModel.isSpeakerSpeaks ? 1 : 0)
                }
            }

            ToolbarItem(placement: .topBarTrailing) {
                Image(systemName: "trash.fill")
                    .bold()
                    .onTapGesture {
                        showAlert.toggle()
                    }
                    .padding(.horizontal)
                    .opacity(coreDataElements.isEmpty ? .zero : 1)
            }

            ToolbarItem(placement: .topBarTrailing) {
                ZStack {
                    Circle()
                        .fill(colorScheme == .dark ? Consts.showCaseDark : Consts.showCaseLight)
                        .frame(width: Consts.Layout.toolbarItemFrameSize, height: Consts.Layout.toolbarItemFrameSize)
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
        .onAppear {
            guard viewModel.isInteractive else { return }
            viewModel.customSpeak("A szkenneléshez használd a job sarokban lévő gombot vagy a képernyő közepén lévőt.")
        }
        .ignoresSafeArea()
        .onDisappear {
            viewModel.didDisAppear()
        }
        .alert(isPresented: $showAlert) {
            Alert(
                title: Text("Törlöd a szkennelt képeket?"),
                message: Text("Ez a művelet nem visszafordítható, de nem kerülnek mentésre a képeid."),
                primaryButton: .cancel(Text("Mégsem")) {
                },
                secondaryButton: .destructive(Text("Igen")) {
                    viewModel.resetLocalDB(context: managedObjectContext)
                }
            )
        }
    }

    // MARK: - Functions

    private func updateHintFlag() {
        withAnimation(.easeInOut(duration: Consts.Animation.baseTime )) {
            self.opacityOfShowCase = self.opacityOfShowCase == .zero ? 1 : .zero
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + Consts.Animation.baseTime + Consts.Animation.extraTime) {
            withAnimation(.interpolatingSpring(duration: Consts.Animation.extraTime * 0.5 )) {
                self.opacityOfShowCase = .zero
            }
        }
    }
}

// MARK: - Preview

#Preview {
    NavigationStack {
        ScanDocumentView()
    }
}
