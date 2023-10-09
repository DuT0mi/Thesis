//
//  CarouselItemView.swift
//  ThesisAccessibilityHelper
//
//  Created by Dudas Tamas Alex on 2023. 10. 09..
//

import SwiftUI

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

    var model: ScanDocumentViewModel.CaoruselModel
    var type: ItemType = .back

    var body: some View {
        BaseView {
            switch type {
                case .front:
                    frontView
                case .back:
                    backView
            }
        }
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
                    Button("Show") {
                        print("DID TAP ID: \(model.id)")
                    }
                    .buttonStyle(.bordered)
                    .buttonBorderShape(.roundedRectangle(radius: Consts.Layout.buttonCornerRadius))
                }
                .tint(.red)
            }
        }
    }
}

#Preview {
    CarouselItemView(model: .init(image: Image(systemName: "house"), detectedText: "House", id: "House".lowercased()))
}
