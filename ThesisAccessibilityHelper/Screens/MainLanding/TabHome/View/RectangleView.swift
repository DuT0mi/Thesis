//
//  RecangleView.swift
//  ThesisAccessibilityHelper
//
//  Created by Dudas Tamas Alex on 2023. 10. 20..
//

import SwiftUI

/// A View that represents the entry point to the authentication flow
/// - Parameters:
///  - systemName: The **SF Symbol** name for the Icon to show on the middle of the rectanlge
///  - isLogged: Flag for decide if it needs to show the Authentication flow or not
///  - onTap: TapGesture entry point
struct RectangleView: View {
    // MARK: - Types

    private struct Consts {
        struct Layout {
            static let rectangleSize: CGFloat = 125
            static let rectangleCornerRadius: CGFloat = 125 * 0.25

            static let imageSize: CGFloat = 44
        }

        struct Appearance {
            static let outerViewBGOpacity: CGFloat = 0.4

            static let lineWidth: CGFloat = 5
        }
    }

    // MARK: - Properties

    var systemName: String
    var isLogged = false
    var onTap: (() -> Void)?

    var body: some View {
        VStack {
            Button {
                onTap?()
            } label: {
                ZStack {
                    Group {
                        RoundedRectangle(cornerRadius: Consts.Layout.rectangleCornerRadius)
                            .fill(Color.gray.opacity(Consts.Appearance.outerViewBGOpacity))
                        RoundedRectangle(cornerRadius: Consts.Layout.rectangleCornerRadius)
                            .stroke(lineWidth: Consts.Appearance.lineWidth)
                            .overlay {
                                Image(systemName: systemName)
                                    .frame(width: Consts.Layout.imageSize, height: Consts.Layout.imageSize)
                                    .foregroundStyle(isLogged ? .red : .black)
                            }
                            .zIndex(1)
                    }
                    .frame(width: Consts.Layout.rectangleSize, height: Consts.Layout.rectangleSize)
                }
            }
            .foregroundStyle(.black)
        }
    }
}

// MARK: - Preview

#Preview("Not Logged") {
    RectangleView(systemName: "person.fill.questionmark")
}

#Preview("Logged") {
    RectangleView(systemName: "person.fill.checkmark", isLogged: true)
}
