//
//  ImagesCarousel.swift
//  ThesisAccessibilityHelper
//
//  Created by Dudas Tamas Alex on 2023. 10. 01..
//

import SwiftUI

struct ImagesCarousel: View {
    // MARK: - Properties

    @Environment(\.verticalSizeClass) private var verticalSizeClass

    var images: [Image]

    var body: some View {
        ScrollView(.horizontal) {
            LazyHStack {
                ForEach(images.indices) { index in
                    images[index]
                        .resizable()
                        .containerRelativeFrame(.horizontal, count: verticalSizeClass == .regular ? 1 : 2, spacing: 16)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                        .scrollTransition { content, phase in
                            content
                                .opacity(phase.isIdentity ? 1 : .zero)
                                .scaleEffect(x: phase.isIdentity ? 1 : 0.2, y: phase.isIdentity ? 1 : 0.2)
                                .offset(y: phase.isIdentity ? 0 : 50)
                        }
                }
                .scrollTargetLayout()
            }
            .contentMargins(16, for: .scrollContent)
        }
    }
}

#Preview {
    ImagesCarousel(images: [Image(.mockImage0)])
}
