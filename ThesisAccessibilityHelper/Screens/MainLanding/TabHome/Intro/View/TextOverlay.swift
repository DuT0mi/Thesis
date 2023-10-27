//
//  TextOverlay.swift
//  ThesisAccessibilityHelper
//
//  Created by Dudas Tamas Alex on 2023. 10. 27..
//

import SwiftUI

struct TextOverlay: View {
    // MARK: - Properties

    var demoCard: DemoItem

    var gradient: LinearGradient {
        .linearGradient(
            Gradient(colors: [.black.opacity(0.6), .black.opacity(0)]),
            startPoint: .bottom,
            endPoint: .center)
    }

    var body: some View {
        ZStack(alignment: .bottomLeading) {
            gradient
            VStack(alignment: .leading) {
                Text(demoCard.title)
                    .font(.title)
                    .bold()
                Text(demoCard.description)
            }
            .padding()
        }
        .foregroundColor(.white)
    }
}
