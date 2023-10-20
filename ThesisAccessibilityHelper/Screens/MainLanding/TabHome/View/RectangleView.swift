//
//  RecangleView.swift
//  ThesisAccessibilityHelper
//
//  Created by Dudas Tamas Alex on 2023. 10. 20..
//

import SwiftUI

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
                                    .foregroundStyle(.black)
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

#Preview {
    RectangleView(systemName: "person.fill")
}
