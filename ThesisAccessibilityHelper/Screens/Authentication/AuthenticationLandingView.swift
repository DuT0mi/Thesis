//
//  AuthenticationLandingView.swift
//  ThesisAccessibilityHelper
//
//  Created by Dudas Tamas Alex on 2023. 09. 09..
//

import SwiftUI

struct AuthenticationLandingView: View {
    // MARK: - Properties

    var body: some View {
        BaseView {
            Text("Auth")
        }
        .ignoresSafeArea()
    }
}

// MARK: - Preview

struct AuthenticationLandingView_Previews: PreviewProvider {
    static var previews: some View {
        AuthenticationLandingView()
    }
}
