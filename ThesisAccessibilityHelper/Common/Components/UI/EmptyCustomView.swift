//
//  EmptyView.swift
//  ThesisAccessibilityHelper
//
//  Created by Dudas Tamas Alex on 2023. 10. 28..
//

import SwiftUI

/// A View that is used as an Empty View (not the same as the default `EmptyView`)
struct EmptyCustomView: View {

    var progressView = false

    var body: some View {
        VStack(spacing: 16 ) {
            ProgressView()
                .frame(width: 30, height: 30)
                .opacity(progressView ? 1 : .zero)
                .accessibilityHidden(progressView ? true : false)
            LottieView(animationName: "emptycart")
                .frame(height: AppConstants.ScreenDimensions.height / 2)
                .padding()
                .accessibilityValue("Animation for empty screen")
            Label("You haven't added any item yet", systemImage: "camera.viewfinder")
        }
    }
}
