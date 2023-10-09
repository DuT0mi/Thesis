//
//  ImagesCarousel.swift
//  ThesisAccessibilityHelper
//
//  Created by Dudas Tamas Alex on 2023. 10. 01..
//

import SwiftUI
import Resolver

struct ImagesCarousel: View {
    // MARK: - Properties

    @ObservedObject private var observedViewModel: ScanDocumentViewModel = Resolver.resolve()
    @Environment(\.verticalSizeClass) private var verticalSizeClass

    @State private var flipped = false

    private var front: Angle { flipped ? .degrees(180) : .degrees(0) }
    private var back: Angle { flipped ? .degrees(0) : .degrees(-180) }

    var models: [ScanDocumentViewModel.CaoruselModel]

    var body: some View {
        ScrollView(.horizontal) {
            LazyHStack {
                if !models.isEmpty {
                    ForEach(models, id: \.id) { model in
                        Button {
                            withAnimation(.spring(.smooth)) { flipped.toggle() }
                        } label: {
                            ZStack {
                                CarouselItemView(model: model, type: .front)
                                    .horizontalFlip(front, visible: !flipped)
                                CarouselItemView(model: model, type: .back)
                                    .horizontalFlip(back, visible: flipped)
                            }
                        }
                        .containerRelativeFrame(.horizontal, count: verticalSizeClass == .regular ? 1 : 2, spacing: 16)
                        .scrollTransition { content, phase in
                            content
                                .opacity(phase.isIdentity ? 1 : .zero)
                                .scaleEffect(x: phase.isIdentity ? 1 : 0.2, y: phase.isIdentity ? 1 : 0.2)
                                .offset(y: phase.isIdentity ? 0 : 50)
                        }
                    }
                    .scrollTargetLayout()
                } else {
                    ProgressView()
                }
            }
            .contentMargins(16, for: .scrollContent)
        }
    }
}

#Preview {
    ImagesCarousel(models: [])
}
