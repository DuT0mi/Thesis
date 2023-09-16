//
//  ObjectView.swift
//  ThesisAccessibilityHelper
//
//  Created by Dudas Tamas Alex on 2023. 09. 16..
//

import SwiftUI

struct ObjectView: View {
    // MARK: - Types

    private struct Consts {
        static let minimalDelay = 0.7
    }

    // MARK: - Properties

    @State private var showText = false

    var resultLabel: String
    var bufferSize: CGRect = .zero

    var body: some View {
        if bufferSize != .zero {
            GeometryReader { geometryProxy in
                VStack {
                    if showText {
                        Text(resultLabel)
                            .position(x: bufferSize.midX, y: bufferSize.midY)
                    }
                }
                .frame(width: geometryProxy.size.width, height: geometryProxy.size.height)
                .onAppear {
                    DispatchQueue.main.asyncAfter(deadline: .now() + Consts.minimalDelay) {
                        showText = true
                    }
                }
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
    }
}
