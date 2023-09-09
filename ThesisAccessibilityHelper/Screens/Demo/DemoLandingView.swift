//
//  DemoLandingView.swift
//  ThesisAccessibilityHelper
//
//  Created by Dudas Tamas Alex on 2023. 09. 09..
//

import SwiftUI

struct DemoLandingView: View {
    var body: some View {
        BaseView {
            Text("Demo View")
        }
        .ignoresSafeArea()
    }
}

struct DemoLandingView_Previews: PreviewProvider {
    static var previews: some View {
        DemoLandingView()
    }
}
