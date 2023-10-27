//
//  PanelView.swift
//  ThesisAccessibilityHelper
//
//  Created by Dudas Tamas Alex on 2023. 10. 14..
//

import SwiftUI

/// A View that defines a Panel based on a __RoundedRectangle__
struct PanelView: View {
    // MARK: - Types

    @ScaledMetric private var fontSize = 16
    @Environment(\.accessibilityReduceTransparency) var accessibilityReduceTransparency
    @Environment(\.colorSchemeContrast) var colorSchemeContrast

    private struct Consts {
        struct Layout {
            static let cornerRadius: CGFloat = 20
        }

        struct Appearance {
            static let opacity: CGFloat = 0.6
        }
    }

    // MARK: - Properties

    var text: String
    var cornerRadius: CGFloat?

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: cornerRadius ?? Consts.Layout.cornerRadius, style: .circular)
                .fill(Color.gray.opacity(accessibilityReduceTransparency ? Consts.Appearance.opacity : Consts.Appearance.opacity * 0.8))
                .overlay {
                    Text(text)
                        .font(Font.system(size: fontSize))
                        .foregroundColor(colorSchemeContrast == .increased ? .white : .primary)
                }
        }
    }
}

// MARK: - Preview

#Preview {
    PanelView(text: "aaa")
        .frame(width: 100, height: 100, alignment: .center)
}
