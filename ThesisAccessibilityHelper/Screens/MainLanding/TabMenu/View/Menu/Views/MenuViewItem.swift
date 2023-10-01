//
//  MenuViewItem.swift
//  ThesisAccessibilityHelper
//
//  Created by Dudas Tamas Alex on 2023. 09. 15..
//

import SwiftUI

struct MenuViewItem: View {
    // MARK: - Consts

    private struct Consts {
        struct Color {
            static let gradient = LinearGradient(colors: [.white, .gray], startPoint: .topTrailing, endPoint: .bottomLeading)
        }

        struct Layout {
            static let frame: CGFloat = 100
            static let shadowRadius: CGFloat = 10
        }
    }

    // MARK: - Properties
    @State private var isHighlighted = false

    var systemName: String = "house"
    var image: ImageResource?

    var body: some View {
        ZStack {
            Circle()
                .fill(Consts.Color.gradient )
                .frame(width: Consts.Layout.frame)
                .shadow(color: .white, radius: Consts.Layout.shadowRadius, x: .zero, y: .zero)
                .overlay {
                    if let image {
                        Image(image)
                            .resizable()
                            .clipShape(Circle())
                            .scaledToFit()
                            .frame(width: Consts.Layout.frame, height: Consts.Layout.frame)
                    } else {
                        Image(systemName: systemName)
                            .resizable()
                            .scaledToFit()
                            .frame(width: Consts.Layout.frame / 2, height: Consts.Layout.frame / 2)
                    }
                }
        }
    }

    // MARK: - Functions

    static func update() {
    }
}

struct MenuViewItem_Previews: PreviewProvider {
    static var previews: some View {
        BaseView {
            MenuViewItem(image: ImageResource.menuCamera)
        }
        .ignoresSafeArea()
    }
}
