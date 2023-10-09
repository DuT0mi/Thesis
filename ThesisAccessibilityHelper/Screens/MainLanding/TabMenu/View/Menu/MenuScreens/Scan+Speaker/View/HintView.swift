//
//  HintView.swift
//  ThesisAccessibilityHelper
//
//  Created by Dudas Tamas Alex on 2023. 10. 01..
//

import SwiftUI

struct HintView: View {
    // MARK: - Types

    private struct Consts {
        struct Layout {
            static let lineWidth: CGFloat = 5
            static let dash: [CGFloat] = [10,15]
            static let dashPhase: CGFloat = 40

            static let imageWidthFactor: CGFloat = 0.9
            static let imageHeight: CGFloat = 100

            static let overlayImageOffsetX: CGFloat = 15
            static let overlayImageOffsetY: CGFloat = 20
        }

        struct Appearance {
            static let textFont: CGFloat = 20
            static let imageFont: CGFloat = 40
            static let overlayImageFont: CGFloat = 25

            static let grayOpacity: CGFloat = 0.2
        }
    }

    // MARK: - Properties

    var body: some View {
        rectangeFactory()
            .strokeBorder(.red, style: .init(
                lineWidth: Consts.Layout.lineWidth,
                lineCap: .square,
                lineJoin: .miter,
                miterLimit: .infinity,
                dash: Consts.Layout.dash,
                dashPhase: Consts.Layout.dashPhase)
            )
            .frame(width: AppConstants.ScreenDimensions.width * Consts.Layout.imageWidthFactor, height: Consts.Layout.imageHeight, alignment: .center)
            .overlay {
                rectangeFactory()
                    .fill(Color.gray.opacity(Consts.Appearance.grayOpacity))
                HStack {
                    Text("Scan&Speak anything with")
                        .bold()
                        .font(.custom("TextTitle", size: Consts.Appearance.textFont))
                    Image(systemName: "doc.viewfinder")
                        .bold()
                        .font(Font(CTFont(.message, size: Consts.Appearance.imageFont)))
                        .overlay(alignment: .topTrailing) {
                            Image(systemName: "hand.tap")
                                .offset(x: Consts.Layout.overlayImageOffsetX, y: Consts.Layout.overlayImageOffsetY)
                                .rotationEffect(.radians(-.pi / 2))
                                .font(Font(CTFont(.message, size: Consts.Appearance.overlayImageFont)))
                        }
                }
            }
    }

    // MARK: - Functions

    private func rectangeFactory() -> RoundedRectangle {
        RoundedRectangle(cornerRadius: 20)
    }
}

#Preview {
    HintView()
}
