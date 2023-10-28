//
//  FoundImages.swift
//  ThesisAccessibilityHelper
//
//  Created by Dudas Tamas Alex on 2023. 10. 11..
//

import SwiftUI
import Resolver

/// A View that shows the found image, based on specified models: ``SortedModel``
/// - Parameters:
///  - showBottomSheet: __Binding__, show a bottom sheet or not
///  - bottomSheetIsLoading: __Binding__, is a bottom sheet is loading or not
struct FoundImagesView: View {
    // MARK: - Types

    private struct Consts {
        struct Layout {
            static let frameSpacing: CGFloat = 16
            static let contentOffsetY: CGFloat = 50
            static let cornerRadius: CGFloat = 15
        }
    }

    // MARK: - Properties

    @Environment(\.dismiss) private var dismiss
    @Environment(\.verticalSizeClass) private var verticalSizeClass
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    @ObservedObject private var mainViewModel: ScanDocumentViewModel = Resolver.resolve()

    @State private var sortedModels: [SortedModel] = []
    @Binding var showBottomSheet: Bool
    @Binding var bottomSheetIsLoading: Bool

    var body: some View {
        BaseView {
            VStack {
                ScrollView(.vertical) {
                    LazyVStack {
                        if !mainViewModel.isSearching, !mainViewModel.sortedModels.isEmpty {
                            ForEach(sortedModels) { viewModelItem in
                                Button {
                                } label: {
                                    VStack {
                                        Text("Distance from refernce: \(viewModelItem.featureprintDistance)")
                                            .minimumScaleFactor(0.7)
                                            .lineLimit(nil)
                                            .bold()
                                            .tint(Color.orange)
                                        viewModelItem.carouselModel.image
                                            .resizable()
                                            .clipped()
                                            .clipShape(RoundedRectangle(cornerRadius: Consts.Layout.cornerRadius))
                                            .frame(width: 200, height: 400)
                                            .overlay {
                                                Label(viewModelItem.carouselModel.detectedText, image: "")
                                                    .minimumScaleFactor(0.7)
                                                    .lineLimit(nil)
                                                    .font(Font.caption2)
                                                    .tint(Color.red)
                                                    .bold()
                                            }
                                    }
                                }
                                .containerRelativeFrame(.vertical, count: horizontalSizeClass == .compact ? 1 : 2, spacing: Consts.Layout.frameSpacing)
                                .scrollTransition { content, phase in
                                    content
                                        .opacity(phase.isIdentity ? 1 : .zero)
                                        .scaleEffect(x: phase.isIdentity ? 1 : 0.2, y: phase.isIdentity ? 1 : 0.2)
                                        .offset(y: phase.isIdentity ? CGFloat.zero : Consts.Layout.contentOffsetY)
                                }
                            }
                            .scrollTargetLayout()
                        } else {
                            EmptyCustomView(progressView: true)
                        }
                    }
                    .contentMargins(16, for: .scrollContent)
                }
                Button("Dismiss") {
                    dismiss.callAsFunction()
                }
                .buttonBorderShape(.capsule)
                .buttonStyle(.borderedProminent)
                .tint(Color.red)
                .padding()
            }
        }
        .ignoresSafeArea()
        .onAppear {
            sortedModels = mainViewModel.sortedModels
            bottomSheetIsLoading = false
        }
        .onDisappear {
            showBottomSheet = false
        }
    }
}

// MARK: - Preview

#Preview {
    FoundImagesView(showBottomSheet: .constant(false), bottomSheetIsLoading: .constant(false))
}
