//
//  PopupView.swift
//  ThesisAccessibilityHelper
//
//  Created by Dudas Tamas Alex on 2023. 10. 20..
//

import SwiftUI

struct PopupView: View {
    // MARK: - Types

    private struct Const {
        struct Image {
            static let size: CGFloat = 44
        }
    }

    var size: Image.Scale = .medium

    // MARK: - Properties

    var body: some View {
        VStack {
            Image(systemName: "person.crop.circle.badge.checkmark")
                .imageScale(size)
                .foregroundColor(Color(red: 0, green: 0.4, blue: 0))
                .bold()
                .padding()
            Spacer()
        }
    }
}

#Preview("Small") {
    PopupView(size: .small)
}

#Preview("Medium") {
    PopupView(size: .medium)
}

#Preview("Large") {
    PopupView(size: .large)
}
