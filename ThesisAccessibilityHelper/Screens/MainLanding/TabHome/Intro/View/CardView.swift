//
//  CardView.swift
//  ThesisAccessibilityHelper
//
//  Created by Dudas Tamas Alex on 2023. 10. 27..
//

import SwiftUI

struct CardView: View {
    // MARK: - Properties

    var demoCard: DemoItem

    var body: some View {
        demoCard.image
            .resizable()
            .aspectRatio(3 / 2, contentMode: .fit)
            .overlay {
                TextOverlay(demoCard: demoCard)
            }
    }
}
