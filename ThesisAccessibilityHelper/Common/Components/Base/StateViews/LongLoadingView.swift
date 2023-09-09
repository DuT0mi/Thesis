//
//  LongLoadingView.swift
//  ThesisAccessibilityHelper
//
//  Created by Dudas Tamas Alex on 2023. 09. 09..
//

import SwiftUI

struct LongLoadingView: View {
    // MARK: - Properties
    @Environment(\.dismiss) private var dismiss
    var body: some View {
        BaseView {
            Color.orange.opacity(0.3)

            VStack(spacing: 25) {
                Text("Ez egy custom sheet")
                    .foregroundColor(.red)

                Button("Dismiss") {
                    dismiss.callAsFunction()
                }
            }
        }
        .ignoresSafeArea()
    }
}

// MARK: - Preview

struct LongLoadingView_Previews: PreviewProvider {
    static var previews: some View {
        LongLoadingView()
    }
}
