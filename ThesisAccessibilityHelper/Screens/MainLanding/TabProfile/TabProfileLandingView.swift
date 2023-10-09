//
//  TabProfileLandingView.swift
//  ThesisAccessibilityHelper
//
//  Created by Dudas Tamas Alex on 2023. 09. 15..
//

import SwiftUI

struct TabProfileLandingView: View {
    // MARK: - Properties

    var body: some View {
        BaseView {
            Text("Profile Landing")
        }
        .ignoresSafeArea()
    }
}

struct TabProfileLandingView_Previews: PreviewProvider {
    static var previews: some View {
        TabProfileLandingView()
    }
}
