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

    @State private var presentBottomSheet = false

    var body: some View {
        ZStack {
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
                presentBottomSheet = true
                viewModel.showHaptic(type: .notification, notificationStyle: .warning)
                viewModel.stopSession()
            }
        })
        .sheet(isPresented: $presentBottomSheet, onDismiss: {
            presentBottomSheet = false
            viewModel.resumeSession()
        }, content: {
            ImageFinderBottomSheetView()
                .sheetStyle(style: .mixed, dismissable: true, showIndicator: true)
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
