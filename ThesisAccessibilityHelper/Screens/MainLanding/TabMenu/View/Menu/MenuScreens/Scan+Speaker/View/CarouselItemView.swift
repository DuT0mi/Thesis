//
//  CarouselItemView.swift
//  ThesisAccessibilityHelper
//
//  Created by Dudas Tamas Alex on 2023. 10. 09..
//

import SwiftUI

struct CarouselItemView: View {
    // MARK: - Types

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
        .clipShape(RoundedRectangle(cornerRadius: 15))
    }

    private var frontView: some View {
        model.image
            .resizable()
            .clipped()
            .clipShape(RoundedRectangle(cornerRadius: 15))
    }

    private var backView: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 15)
                .fill(Color.black.opacity(0.6))
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
                    .buttonBorderShape(.roundedRectangle(radius: 12))
                }
                .tint(.red)
            }
        }
    }
}

#Preview {
    CarouselItemView(model: .init(image: Image(systemName: "house"), detectedText: "House", id: "House".lowercased()))
}
