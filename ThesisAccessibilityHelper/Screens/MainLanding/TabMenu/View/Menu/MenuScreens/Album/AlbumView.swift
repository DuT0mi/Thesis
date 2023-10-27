//
//  AlbumView.swift
//  ThesisAccessibilityHelper
//
//  Created by Dudas Tamas Alex on 2023. 10. 04..
//

import SwiftUI

struct AlbumView: View {
    // MARK: - Types

    private struct Consts {
        struct Layout {
            static let columns = 3

            static let imageAspectRatio: CGFloat = 1
            static let imageFrameWidth: CGFloat = 100
            static let imageClipShapeCornerRadius: CGFloat = 12
        }
    }

    // MARK: - Properties

    @Environment(\.managedObjectContext) private var managedObjectContext
    @FetchRequest(sortDescriptors: [SortDescriptor(\.resultID)]) private var coreDataElements: FetchedResults<TempData>

    @StateObject private var viewModel = AlbumViewModel()
    @Namespace private var nameSpace

    @State private var isPresentingConfirm = false
    @State var currentAmount: CGFloat = .zero
    @State var lastAmount: CGFloat = .zero
    @State private var selectedItem: AlbumViewModel.AlbumModel?

    @ScaledMetric private var textFont = 20

    private let columns = Array(repeating: GridItem(), count: Consts.Layout.columns)

    var body: some View {
        BaseView {
            if viewModel.isLoading {
                ProgressView()
            }
            if !coreDataElements.isEmpty {
                coreDataElementsView
                    .opacity(selectedItem == nil ? 1 : .zero)
            } else {
                emptyView
            }

            selectedItemView
        }
        .confirmationDialog("Are you sure?", isPresented: $isPresentingConfirm) {
            Button("Delete all items?", role: .destructive) {
                viewModel.deleteAllItem(on: managedObjectContext)
            }
        } message: {
            Text("You cannot undo this action")
        }
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    viewModel.speak(selectedItem?.detectedText ?? "")
                } label: {
                    Image(systemName: "speaker.wave.2.bubble.left.fill")
                        .accessibilityHidden(selectedItem == nil ? true : false)
                        .accessibilityValue("Use that button for hear the detected text")
                }
                .opacity(selectedItem == nil ? .zero : 1)
            }

            ToolbarItem(placement: .topBarTrailing) {
                Button {
                } label: {
                    Image(systemName: "rectangle.and.text.magnifyingglass")
                        .accessibilityAddTraits(.isButton)
                        .accessibilityValue("Use that button for delete all the images from your phone")
                        .accessibilityHint("Tap for it")
                }
                .contextMenu {
                    contextMenu
                }
            }
        }
        .task {
            viewModel.mapper(coreDataElements)
        }
    }

    private var coreDataElementsView: some View {
        ScrollView(.vertical) {
            LazyVGrid(columns: columns) {
                ForEach(viewModel.model, id: \.modelID) { item in
                    item.image
                        .resizable()
                        .aspectRatio(Consts.Layout.imageAspectRatio, contentMode: .fit)
                        .frame(width: Consts.Layout.imageFrameWidth)
                        .matchedGeometryEffect(id: item.modelID, in: nameSpace)
                        .clipShape(.rect(cornerRadius: Consts.Layout.imageClipShapeCornerRadius))
                        .onTapGesture {
                            withAnimation(.spring(dampingFraction: 0.7)) {
                                selectedItem = item
                            }
                        }
                        .accessibilityValue("Its detected text: \(item.detectedText)")
                        .accessibilityAddTraits(.isButton)
                        .accessibilityHint("Tap for open the selected image")
                }
            }
        }
    }

    private var emptyView: some View {
        VStack(spacing: 16 ) {
            LottieView(animationName: "emptycart")
                .frame(height: AppConstants.ScreenDimensions.height / 2)
                .padding()
            Label("You haven't added any item yet", systemImage: "camera.viewfinder")
        }
    }

    @ViewBuilder
    private var contextMenu: some View {
        Menu {
            AnimatedActionButton(title: "Delete all", systemImage: "trash") {
                isPresentingConfirm.toggle()
            }
            .disabled(isDeleteButtonDisabled)
        } label: {
            Text("Options")
        }
    }

    @ViewBuilder private var selectedItemView: some View {
        if let selectedItem {
            LazyVStack {
                ScrollView {
                    Text(selectedItem.detectedText)
                        .font(.system(size: textFont))
                        .foregroundStyle(.primary)
                }
                .frame(maxWidth: .infinity, maxHeight: AppConstants.AppDimension.width * 0.2)
                Spacer(minLength: 32)
                selectedItem.image
                    .resizable()
                    .frame(width: AppConstants.AppDimension.width * 0.8, height: AppConstants.AppDimension.width * 0.8)
                    .scaleEffect(1 + currentAmount + lastAmount)
                    .matchedGeometryEffect(id: selectedItem.modelID, in: nameSpace)
                    .onTapGesture {
                        withAnimation(.spring(dampingFraction: 0.7)) {
                            self.selectedItem = nil
                        }
                    }
                    .simultaneousGesture(
                        MagnificationGesture()
                            .onChanged { value in
                                currentAmount = value - 1
                            }
                            .onEnded { _ in
                                currentAmount = .zero
                            }
                    )
                    .padding()
            }
        }
    }

    private var isDeleteButtonDisabled: Bool {
        coreDataElements.isEmpty || viewModel.isLoading
    }

    // MARK: - Functions
}

// MARK: - Preview

#Preview {
    AlbumView()
}
