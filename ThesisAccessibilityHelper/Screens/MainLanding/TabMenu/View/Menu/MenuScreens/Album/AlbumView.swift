//
//  AlbumView.swift
//  ThesisAccessibilityHelper
//
//  Created by Dudas Tamas Alex on 2023. 10. 04..
//

import SwiftUI

struct AlbumView: View {
    // MARK: - Properties

    @Environment(\.managedObjectContext) private var managedObjectContext
    @FetchRequest(sortDescriptors: [SortDescriptor(\.resultID)]) private var coreDataElements: FetchedResults<TempData>

    @StateObject private var viewModel = AlbumViewModel()

    private let columns = Array(repeating: GridItem(), count: 3)

    var body: some View {
        BaseView {
            ScrollView(.vertical) {
                LazyVGrid(columns: columns) {
                    if !coreDataElements.isEmpty {
                        ForEach(coreDataElements, id: \.resultID) { tempData in
                            Image(uiImage: UIImage(data: tempData.imageData!)!)
                                .resizable()
                                .aspectRatio(1.0, contentMode: .fit)
                                .frame(width: 100)
                                .clipShape(.rect(cornerRadius: 12))
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
//        .ignoresSafeArea()
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
