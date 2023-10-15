//
//  CarouselItemView.swift
//  ThesisAccessibilityHelper
//
//  Created by Dudas Tamas Alex on 2023. 10. 09..
//

import SwiftUI
import Resolver

struct CarouselItemView: View {
    // MARK: - Types

    private struct Consts {
        struct Layout {
            static let cornerRadius: CGFloat = 15

            static let buttonCornerRadius: CGFloat = 12
        }

        struct Appearance {
            static let grayOpacity: CGFloat = 0.6
        }
    }

    enum ItemType {
        case back
        case front
    }

    // MARK: - Properties

    @ObservedObject private var scanViewModel: ScanDocumentViewModel = Resolver.resolve()
    @Environment(\.managedObjectContext) private var managedObjectContext
    @FetchRequest(sortDescriptors: [SortDescriptor(\.resultID)]) private var coreDataElements: FetchedResults<TempData>

    @State private var showBottomSheet = false
    @Binding var bottomSheetIsLoading: Bool

    var model: CarouselModel
    var type: ItemType = .back
    var showButton = true

    var body: some View {
        BaseView {
            switch type {
                case .front:
                    frontView
                case .back:
                    backView
            }
        }
        .sheet(isPresented: $showBottomSheet, content: {
            FoundImagesView(showBottomSheet: $showBottomSheet, bottomSheetIsLoading: $bottomSheetIsLoading)
                .sheetStyle(style: .large, dismissable: false, showIndicator: true)
        })
        .clipShape(RoundedRectangle(cornerRadius: Consts.Layout.cornerRadius))
    }

    private var frontView: some View {
        model.image
            .resizable()
            .clipped()
            .clipShape(RoundedRectangle(cornerRadius: Consts.Layout.cornerRadius))
    }

    private var backView: some View {
        ZStack {
            RoundedRectangle(cornerRadius: Consts.Layout.cornerRadius)
                .fill(Color.black.opacity(Consts.Appearance.grayOpacity))
            ScrollView {
                LazyVStack {
                    Text(model.detectedText)
                        .lineLimit(nil)
                        .font(.caption2)
                    Spacer()
                    if showButton {
                        Button("Find similar") {
                            showBottomSheet.toggle()
                            bottomSheetIsLoading = true
                            
                            scanViewModel.findSimilarImages(localDataBase: coreDataElements, search: model)
                        }
                        .buttonStyle(.bordered)
                        .buttonBorderShape(.roundedRectangle(radius: Consts.Layout.buttonCornerRadius))
                    }
                }
                .tint(.red)
            }
        }
    }
}

#Preview {
    CarouselItemView(bottomSheetIsLoading: .constant(false), model: .init(id: "House".lowercased(), image: Image(systemName: ""), imageData: Data(), detectedText: ""))
}
