//
//  TabMenuLandingView.swift
//  ThesisAccessibilityHelper
//
//  Created by Dudas Tamas Alex on 2023. 09. 15..
//

import SwiftUI

struct TabMenuLandingView: View {
    var body: some View {
        BaseView {
            MenuView()
        }
        .ignoresSafeArea()
    }
}

struct TabMenuLandingView_Previews: PreviewProvider {
    static var previews: some View {
        TabMenuLandingView()
    }
}
