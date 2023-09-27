//
//  MenuViewItem.swift
//  ThesisAccessibilityHelper
//
//  Created by Dudas Tamas Alex on 2023. 09. 15..
//

import SwiftUI

struct MenuViewItem: View {
    // MARK: - Properties

    var systemName: String = "house"
    var image: ImageResource?

    var body: some View {
        ZStack {
            Circle()
                .fill(Color.white)
                .frame(width: 100)
                .shadow(color: .white, radius: 10, x: .zero, y: .zero)
                .overlay {
                    if let image {
                        Image(image)
                            .resizable()
                            .clipShape(Circle())
                            .scaledToFit()
                            .frame(width: 100, height: 100)
                    } else {
                        Image(systemName: systemName)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 50, height: 50)
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
