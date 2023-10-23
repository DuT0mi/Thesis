//
//  ObjectView.swift
//  ThesisAccessibilityHelper
//
//  Created by Dudas Tamas Alex on 2023. 09. 16..
//

import SwiftUI
import Combine

/// The detected object view at the corresponding position
/// - Parameters:
///  - resultLabel: The label of the founds object
///  - bufferSize: The position of the found object
struct ObjectView: View {
    // MARK: - Types

    private struct Consts {
        struct Appearance {
            static let timerInterval: TimeInterval = 0.5
            static let timerTolerance: TimeInterval = 0.33
            static let timerLimit: TimeInterval = 2.5
        }
    }

    // MARK: - Properties

    var resultLabel: String
    var bufferSize: CGRect

    var body: some View {
        if bufferSize.width != .zero, bufferSize.height != .zero {
            GeometryReader { geometryProxy in
                let nonNegativeX = max(0, bufferSize.minX)
                let adjustedBufferSize = CGRect(x: nonNegativeX, y: bufferSize.minY, width: bufferSize.width, height: bufferSize.height)

                ZStack {
                    Text(resultLabel)
                        .position(x: adjustedBufferSize.midY, y: adjustedBufferSize.minY - 10)
                    Rectangle()
                        .strokeBorder(lineWidth: 1.0)
                        .foregroundColor(.white)
                        .background(Color.yellow.opacity(0.2))
                        .frame(width: adjustedBufferSize.width, height: adjustedBufferSize.height)
                        .position(x: adjustedBufferSize.midX, y: adjustedBufferSize.midY)
                }
                .frame(width: geometryProxy.size.width, height: geometryProxy.size.height)
            }
        } else {
            EmptyView()
                .opacity(0)
        }
    }
}

struct ObjectView_Previews: PreviewProvider {
    static var previews: some View {
        ObjectView(resultLabel: "Hello", bufferSize: .init(x: 10, y: 10, width: 200, height: 200))
            .preferredColorScheme(.dark)
    }
}
