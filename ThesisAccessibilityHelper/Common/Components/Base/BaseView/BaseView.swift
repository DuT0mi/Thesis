//
//  BaseView.swift
//  ThesisAccessibilityHelper
//
//  Created by Dudas Tamas Alex on 2023. 09. 09..
//

import SwiftUI

protocol BaseViewInput {
}

extension BaseViewInput {
}

struct BaseView<Content>: View where Content: View {
    // MARK: - Types

    struct GradientConfiguration {
        // MARK: - GradientConfiguration properties

        var colors: [Color]
        var colorsOpacity: CGFloat = .zero {
            willSet {
                guard newValue < AppConstants.AppColor.opacityNewValueMax, newValue > AppConstants.AppColor.opacityNewValueMin, newValue != colorsOpacity else { return }
                updateColors(newValue)
            }
        }
        var gradientStart: UnitPoint
        var gradientEnd: UnitPoint

        // MARK: - GradientConfiguration pnitialization

        init(
            colors: [Color] = [
                .white.opacity(AppConstants.AppColor.opacityDefaultLow),
                .white.opacity(AppConstants.AppColor.opacityDefaultMedium),
                .gray.opacity(AppConstants.AppColor.opacityDefaultLow)
            ],
            colorsOpacity: CGFloat = AppConstants.AppColor.opacityDefaultMedium,
            gradientStart: UnitPoint = .center,
            gradientEnd: UnitPoint = .topTrailing,
            shouldIgnoreSafeArea: Bool = true
        ) {
            self.colors = colors
            self.colorsOpacity = colorsOpacity
            self.gradientStart = gradientStart
            self.gradientEnd = gradientEnd
        }

        // MARK: - GradientConfiguration functions

        mutating private func updateColors(_ newValue: CGFloat) {
            self.colors = self.colors.map { $0.opacity(newValue) }
        }
    }

    // MARK: - Properties

    let content: Content

    let configuration: GradientConfiguration

    // MARK: - Initialization

    init(configuration: GradientConfiguration = .init(), @ViewBuilder content: () -> Content) {
        self.configuration = configuration
        self.content = content()
    }

    // MARK: - View

    var body: some View {
        ZStack {
            LinearGradient(colors: configuration.colors, startPoint: configuration.gradientStart, endPoint: configuration.gradientEnd)
            content
        }
    }
}

// MARK: - BaseViewInput

extension BaseView: BaseViewInput {
}

// MARK: - BaseView_Previews

struct BaseView_Previews: PreviewProvider {
    static var previews: some View {
        BaseView {
            Text("Base View")
        }
    }
}
