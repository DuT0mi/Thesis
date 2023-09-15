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

    var body: some View {
        ZStack {
            Circle()
                .fill(Color.gray.opacity(0.5))
                .frame(width: 100)
                .shadow(color: .white, radius: 10, x: .zero, y: .zero)
                .overlay {
                    Image(systemName: systemName)
                        .resizable()
                        .frame(width: 50, height: 50)
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
            MenuViewItem(systemName: "house")
        }
        .ignoresSafeArea()
    }
}


