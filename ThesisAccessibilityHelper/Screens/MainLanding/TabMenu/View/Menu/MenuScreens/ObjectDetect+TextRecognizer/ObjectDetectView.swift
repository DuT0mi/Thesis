//
//  ObjectDetectView.swift
//  ThesisAccessibilityHelper
//
//  Created by Dudas Tamas Alex on 2023. 09. 16..
//

import SwiftUI

struct ObjectDetectView: View {
    // MARK: - Types

    private struct Consts {
        struct EventHandle {
            static let minimumTapDuration: Double = 2.0
            static let maximumDistance: CGFloat = 30
        }
    }

    // MARK: - Properties

    @StateObject private var viewModel = ObjectDetectViewModel()
    @Environment(\.displayScale) private var displayScale

    @State private var presentBottomSheet = false
    @State private var savedImage: UIImage?
    @State private var isLoading = false

    var body: some View {
        ZStack {
            if isLoading {
                ProgressView()
            }
            CameraFrameView(image: viewModel.frame)
                .ignoresSafeArea()
            ObjectView(
                resultLabel: viewModel.capturedObject.capturedLabel,
                bufferSize: viewModel.capturedObject.capturedObjectBounds
            )
        }.onLongPressGesture(minimumDuration: Consts.EventHandle.minimumTapDuration, maximumDistance: Consts.EventHandle.maximumDistance, perform: {
            print("GESTURE | EVENT PERFORMS")
        }, onPressingChanged: { pressDidChange in
            if !pressDidChange {
                isLoading.toggle()
                savedImage = self.snapshot()

                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    presentBottomSheet = true
                    isLoading.toggle()
                    viewModel.showHaptic(type: .notification, notificationStyle: .warning)
                    viewModel.stopSession()
                }
            }
        })
        .sheet(isPresented: $presentBottomSheet, onDismiss: {
            presentBottomSheet = false
            viewModel.resumeSession()
        }, content: {
            ImageFinderBottomSheetView(
                image: Image(uiImage: savedImage ?? UIImage(resource: .menuDocument)), // TODO: Loading image
                model: .init(frame: viewModel.frame, cameraModel: viewModel.capturedObject)
            )
            .sheetStyle(style: .large, dismissable: true, showIndicator: true)
        })
        .onDisappear {
            // Required because of the .snapshot() modifier will disappearing the view itself
            if !isLoading {
                viewModel.didDisAppear()
            }
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
