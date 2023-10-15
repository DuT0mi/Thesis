//
//  ImageFinderBottomSheetView.swift
//  ThesisAccessibilityHelper
//
//  Created by Dudas Tamas Alex on 2023. 10. 13..
//

import SwiftUI
import Resolver
import VolumeButtonHandler

struct ImageFinderBottomSheetView: View {
    // MARK: - Types

    private struct Consts {
        struct Layout {
            static let lineWidth: CGFloat = 7
            static let dash: [CGFloat] = [10, 15]
            static let dashPhase: CGFloat = 40
        }
    }

    // MARK: - Properties

    @ObservedObject private var scanViewModel: ScanDocumentViewModel = Resolver.resolve()
    @Environment(\.dismiss) private var dismiss
    @State private var volumeHandler = VolumeButtonHandler()
    @State private var currentImageSize: CGSize = .zero
    @State private var shouldScale = false

    var image: Image?
    var model: ImageFinderBottomSheetModel

    var body: some View {
        BaseView {
            VStackLayout {
                HStack {
                    toolBarItemLeading
                    Spacer()
                    toolBarItem
                }
                PanelView(text: "Talált objektum: \(model.cameraModel.capturedLabel)")
                    .frame(height: 75)
                    .padding(.horizontal)
                ScrollView {
                    ZStack {
                        LazyVStack {
                            #if targetEnvironment(simulator)
                                Image(.mockImage0)
                                    .resizable()
                                    .frame(width: 480 * 0.8, height: 640 * 0.8)
                                    .clipShape(.rect(cornerRadius: 640 * 0.4 * 0.1))
                            #else
                            if let image {
                                image
                                    .resizable()
                                    .frame(width: currentImageSize.width * 0.8, height: currentImageSize.height * 0.8)
                                    .clipShape(.rect(cornerRadius: currentImageSize.height * 0.4 * 0.1))
                                    .scaleEffect(x: shouldScale ? 0.9 : 0.8, y: shouldScale ? 0.9 : 0.8)
                                    .onTapGesture {
                                        withAnimation(.easeInOut(duration: 1.0)) {
                                            shouldScale.toggle()
                                        }
                                    }
                                    .overlay {
                                        RoundedRectangle(cornerRadius: currentImageSize.height * 0.4 * 0.1)
                                            .strokeBorder(.black, style: .init(
                                                lineWidth: Consts.Layout.lineWidth,
                                                lineCap: .square,
                                                lineJoin: .miter,
                                                miterLimit: .infinity,
                                                dash: Consts.Layout.dash,
                                                dashPhase: Consts.Layout.dashPhase)
                                            )
                                            .frame(width: currentImageSize.width * 0.74, height: currentImageSize.height * 0.74)
                                            .opacity(shouldScale ? 1 : .zero)
                                    }
                                    .overlay(alignment: .topLeading) {
                                        ImageCoordinatePointView(text: "(0,0)")
                                            .opacity(shouldScale ? 1 : .zero)
                                            .offset(x: currentImageSize.height * 0.3 * 0.05, y: currentImageSize.height * 0.4 * 0.05)
                                    }
                                    .overlay(alignment: .topTrailing) {
                                        ImageCoordinatePointView(text: "(\(String(format: "%0.2f", currentImageSize.width)),0)")
                                            .opacity(shouldScale ? 1 : .zero)
                                            .offset(x: -currentImageSize.height * 0.3 * 0.05, y: currentImageSize.height * 0.4 * 0.05)
                                    }
                                    .overlay(alignment: .bottomLeading) {
                                        ImageCoordinatePointView(text: "(0,\(String(format: "%0.2f", currentImageSize.height)))")
                                            .opacity(shouldScale ? 1 : .zero)
                                            .offset(x: currentImageSize.height * 0.3 * 0.05, y: -currentImageSize.height * 0.4 * 0.05)
                                    }
                                    .overlay(alignment: .bottomTrailing) {
                                        ImageCoordinatePointView(text: "(\(String(format: "%0.2f", currentImageSize.width)),\(String(format: "%0.2f", currentImageSize.height)))")
                                            .opacity(shouldScale ? 1 : .zero)
                                            .offset(x: -currentImageSize.height * 0.3 * 0.05, y: -currentImageSize.height * 0.4 * 0.05)
                                    }
                            } else {
                                ProgressView() // TODO: Custom Error
                            }
                            #endif
                        }
                    }
                }
            }
        }
        .task(priority: .high) {
            volumeHandler.startHandler(disableSystemVolumeHandler: false)
            setup()
        }
        .onAppear {
            guard let frame = model.frame else { return }
            currentImageSize = .init(width: frame.width, height: frame.height)

            if model.cameraModel.capturedLabel.isEmpty || model.cameraModel.capturedObjectBounds.equalTo(.zero) {
                scanViewModel.playSound(.error)
            } else {
                scanViewModel.playSound(.success)
            }

            shouldScale.toggle()
            if scanViewModel.isInteractive {
                scanViewModel.showInfo()
            }

            print("MINX \(model.cameraModel.capturedObjectBounds.minX)")
            print("MAXX \(model.cameraModel.capturedObjectBounds.maxX)")
            print("MINY \(model.cameraModel.capturedObjectBounds.minY)")
            print("MAXY \(model.cameraModel.capturedObjectBounds.maxY)")
        }
        .onDisappear {
            if scanViewModel.isInteractive {
                scanViewModel.stop()
            }
        }
        .ignoresSafeArea()
    }

    private var toolBarItem: some View {
        Image(systemName: "xmark.square.fill")
            .resizable()
            .frame(width: 28, height: 28)
            .foregroundStyle(.red)
            .shadow(color: .secondary.opacity(0.5), radius: 5, x: .zero, y: .zero)
            .onTapGesture {
                dismiss.callAsFunction()
            }
    }

    private var toolBarItemLeading: some View {
        Image(systemName: "info.bubble")
            .resizable()
            .frame(width: 28, height: 28)
            .foregroundStyle(.blue)
            .shadow(color: .secondary.opacity(0.5), radius: 5, x: .zero, y: .zero)
            .onTapGesture {
                scanViewModel.showInfo()
            }
    }

    // MARK: - Functions

    private func setup() {
        volumeHandler.upBlock = {
            self.scanViewModel.didTapVolumeButton(direction: .up, model: model)
        }

        volumeHandler.downBlock = {
            self.scanViewModel.didTapVolumeButton(direction: .down, model: model)
        }
    }
}

#Preview {
    ImageFinderBottomSheetView(image: Image(systemName: "house"), model: .init(cameraModel: CameraManager.defaultCameraResultModel))
}
