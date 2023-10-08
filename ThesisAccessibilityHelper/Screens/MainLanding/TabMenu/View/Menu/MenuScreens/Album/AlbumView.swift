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

    private let columns = Array(repeating: GridItem(.flexible()), count: 3)

    var body: some View {
        BaseView {
            NavigationStack {
                ScrollView(.vertical) {
                    LazyVGrid(columns: columns) {
                        if !coreDataElements.isEmpty {
                            ForEach(coreDataElements, id: \.resultID) { tempData in
                                Image(uiImage: UIImage(data: tempData.imageData!)!)
                                    .resizable()
                                    .aspectRatio(1.0, contentMode: .fit)
                                    .frame(width: 100)
                            }
                        } else {
                            ProgressView()
                        }
                    }
                }
            }
        }
        .onAppear {
//            viewModel.didAppear()
        }
        .ignoresSafeArea()
    }
}

#Preview {
    AlbumView()
}
