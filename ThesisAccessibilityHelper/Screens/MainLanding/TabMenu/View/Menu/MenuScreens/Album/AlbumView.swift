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
    @State private var isPresentingConfirm = false

    private let columns = Array(repeating: GridItem(), count: Consts.Layout.columns)

    var body: some View {
        BaseView {
            if viewModel.isLoading {
                ProgressView()
            }
            if !coreDataElements.isEmpty {
                ScrollView(.vertical) {
                    LazyVGrid(columns: columns) {
                        ForEach(coreDataElements, id: \.resultID) { tempData in
                            Image(uiImage: UIImage(data: tempData.imageData!)!)
                                .resizable()
                                .aspectRatio(Consts.Layout.imageAspectRatio, contentMode: .fit)
                                .frame(width: Consts.Layout.imageFrameWidth)
                                .clipShape(.rect(cornerRadius: Consts.Layout.imageClipShapeCornerRadius))
                        }
                    }
                }
            } else {
                VStack(spacing: 16) {
                    LottieView(animationName: "emptycart")
                        .frame(height: AppConstants.ScreenDimensions.height / 2)
                        .padding()
                    Label("You haven't added any item yet", systemImage: "camera.viewfinder")
                }
            }
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
                } label: {
                    Image(systemName: "rectangle.and.text.magnifyingglass")
                }
                .contextMenu {
                    contextMenu
                }
            }
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

    private var isDeleteButtonDisabled: Bool {
        coreDataElements.isEmpty || viewModel.isLoading
    }

    // MARK: - Functions
}

// MARK: - Preview

#Preview {
    AlbumView()
}
