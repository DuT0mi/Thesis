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

    private let columns = Array(repeating: GridItem(), count: Consts.Layout.columns)

    var body: some View {
        BaseView {
            ScrollView(.vertical) {
                LazyVGrid(columns: columns) {
                    if !coreDataElements.isEmpty {
                        ForEach(coreDataElements, id: \.resultID) { tempData in
                            Image(uiImage: UIImage(data: tempData.imageData!)!)
                                .resizable()
                                .aspectRatio(Consts.Layout.imageAspectRatio, contentMode: .fit)
                                .frame(width: Consts.Layout.imageFrameWidth)
                                .clipShape(.rect(cornerRadius: Consts.Layout.imageClipShapeCornerRadius))
                        }
                    } else {
                        ProgressView()
                    }
                }
            }
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
            AnimatedActionButton(title: "Find similary images", systemImage: "text.viewfinder") {
            }
        } label: {
            Text("Options")
        }
    }

    // MARK: - Functions
}

#Preview {
    AlbumView()
}
