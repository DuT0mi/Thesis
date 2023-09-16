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
            // Error view / alert
        }
        .onDisappear {
            viewModel.didDisAppear()
        }
    }
}

struct ObjectDetectView_Previews: PreviewProvider {
    static var previews: some View {
        ObjectDetectView()
    }
}
