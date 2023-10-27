//
//  LottieView.swift
//  ThesisAccessibilityHelper
//
//  Created by Dudas Tamas Alex on 2023. 10. 27..
//

import SwiftUI
import Lottie

struct LottieView: UIViewRepresentable {
    // MARK: - Properties

    var animationName: String

    // MARK: - Functions

    func makeUIView(context: Context) -> AnimationView {
        let view = AnimationView(name: animationName, bundle: Bundle.main)

        view.loopMode = .loop

        view.play()

        return view
    }

    func updateUIView(_ uiView: AnimationView, context: Context) {
        //
    }
}
