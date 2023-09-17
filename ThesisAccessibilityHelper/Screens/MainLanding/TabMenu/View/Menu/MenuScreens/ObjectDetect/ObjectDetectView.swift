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

    var body: some View {
        ZStack {
            CameraFrameView(image: viewModel.frame)
                .ignoresSafeArea()
            ObjectView(resultLabel: viewModel.resultLabel?.identifier, bufferSize: viewModel.bufferSize)
        }
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
