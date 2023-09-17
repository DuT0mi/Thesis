//
//  ObjectView.swift
//  ThesisAccessibilityHelper
//
//  Created by Dudas Tamas Alex on 2023. 09. 16..
//

import SwiftUI

struct ObjectView: View {
    // MARK: - Properties

    var resultLabel: String?
    var bufferSize: CGRect?

    var body: some View {
        if let bufferSize, let resultLabel {
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
