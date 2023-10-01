//
//  HintView.swift
//  ThesisAccessibilityHelper
//
//  Created by Dudas Tamas Alex on 2023. 10. 01..
//

import SwiftUI

struct HintView: View {
    // MARK: - Properties

    var body: some View {
        rectangeFactory()
            .strokeBorder(.red, style: .init(lineWidth: 5, lineCap: .square, lineJoin: .miter, miterLimit: .infinity, dash: [10, 15], dashPhase: 40))
            .frame(width: AppConstants.ScreenDimensions.width * 0.9, height: 100, alignment: .center)
            .overlay {
                rectangeFactory()
                    .fill(Color.gray.opacity(0.2))
                HStack {
                    Text("Scan&Speak anything with")
                        .bold()
                        .font(.custom("TextTitle", size: 20))
                    Image(systemName: "doc.viewfinder")
                        .bold()
                        .font(Font(CTFont(.message, size: 40)))
                        .overlay(alignment: .topTrailing) {
                            Image(systemName: "hand.tap")
                                .offset(x: 15, y: 20)
                                .rotationEffect(.radians(-.pi / 2))
                                .font(Font(CTFont(.message, size: 25)))
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
