//
//  ObjectView.swift
//  ThesisAccessibilityHelper
//
//  Created by Dudas Tamas Alex on 2023. 09. 16..
//

import SwiftUI

struct ObjectView: View {
    // MARK: - Types

    // MARK: - Properties

    var resultLabel: String
    var bufferSize: CGRect = .zero

    var body: some View {
        if bufferSize != .zero {
            GeometryReader { geometryProxy in
                ZStack {
                    Text(resultLabel)
                        .position(x: bufferSize.midY, y: bufferSize.minY - 10)
                    Rectangle()
                        .strokeBorder(lineWidth: 5.0)
                        .foregroundColor(.white)
                        .background(Color.yellow.opacity(0.2))
                        .frame(width: bufferSize.width, height: bufferSize.height)
                        .position(x: bufferSize.midX, y: bufferSize.midY)
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

