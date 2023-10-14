//
//  PanelView.swift
//  ThesisAccessibilityHelper
//
//  Created by Dudas Tamas Alex on 2023. 10. 14..
//

import SwiftUI

struct PanelView: View {
    // MARK: - Types

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
                .fill(Color.gray.opacity(Consts.Appearance.opacity))
                .overlay {
                    Text(text)
                }
        }
    }
}

#Preview {
    PanelView(text: "")
}
