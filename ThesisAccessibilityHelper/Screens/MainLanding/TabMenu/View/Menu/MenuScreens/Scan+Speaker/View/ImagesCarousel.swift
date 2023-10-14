//
//  ImagesCarousel.swift
//  ThesisAccessibilityHelper
//
//  Created by Dudas Tamas Alex on 2023. 10. 01..
//

import SwiftUI
import Resolver

struct ImagesCarousel: View {
    // MARK: - Types

    private struct Consts {
        struct Layout {
            static let frameSpacing: CGFloat = 16
            static let contentOffsetY: CGFloat = 50
        }
    }

    // MARK: - Properties

    @ObservedObject private var observedViewModel: ScanDocumentViewModel = Resolver.resolve()
    @Environment(\.verticalSizeClass) private var verticalSizeClass

    @State private var flipped = false
    @State private var bottomSheetIsLoading = false

    private var front: Angle { flipped ? .degrees(180) : .degrees(0) }
    private var back: Angle { flipped ? .degrees(0) : .degrees(-180) }

    var models: [CarouselModel]

    var body: some View {
        ScrollView(.horizontal) {
            LazyHStack {
                if !models.isEmpty {
                    if bottomSheetIsLoading {
                        ProgressView()
                    }
                    ForEach(models, id: \.id) { model in
                        Button {
                            withAnimation(.spring(.smooth)) { flipped.toggle() }
                        } label: {
                            ZStack {
                                CarouselItemView(bottomSheetIsLoading: .constant(false), model: model, type: .front)
                                    .horizontalFlip(front, visible: !flipped)
                                CarouselItemView(bottomSheetIsLoading: $bottomSheetIsLoading, model: model, type: .back)
                                    .horizontalFlip(back, visible: flipped)
                            }
                        }
                        .containerRelativeFrame(.horizontal, count: verticalSizeClass == .regular ? 1 : 2, spacing: Consts.Layout.frameSpacing)
                        .scrollTransition { content, phase in
                            content
                                .opacity(phase.isIdentity ? 1 : .zero)
                                .scaleEffect(x: phase.isIdentity ? 1 : 0.2, y: phase.isIdentity ? 1 : 0.2)
                                .offset(y: phase.isIdentity ? CGFloat.zero : Consts.Layout.contentOffsetY)
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
