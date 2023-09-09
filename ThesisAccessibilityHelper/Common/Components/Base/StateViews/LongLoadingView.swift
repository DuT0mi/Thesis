//
//  LongLoadingView.swift
//  ThesisAccessibilityHelper
//
//  Created by Dudas Tamas Alex on 2023. 09. 09..
//

import SwiftUI

struct LongLoadingView: View {
    var body: some View {
        BaseView {
            Color.orange.opacity(0.3)
            Text("Ez egy custom sheet")
                .foregroundColor(.red)
        }
        .ignoresSafeArea()
    }
}

struct LongLoadingView_Previews: PreviewProvider {
    static var previews: some View {
        LongLoadingView()
    }
}
