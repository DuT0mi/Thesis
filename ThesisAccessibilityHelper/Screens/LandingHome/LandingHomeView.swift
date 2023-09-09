//
//  LandingHomeView.swift
//  ThesisAccessibilityHelper
//
//  Created by Dudas Tamas Alex on 2023. 09. 09..
//

import SwiftUI

struct LandingHomeView: View {
    // MARK: - Properties

    @State var tester = false // -> Tester

    var body: some View {
        BaseView {
            Button("Landing Home View") {
                tester.toggle()
            }
        }
        .ignoresSafeArea()
        .sheet(isPresented: $tester, content: {
            LongLoadingView()
                .sheetStyle(style: .medium, dismissable: false, showIndicator: true)
        })
    }
}

// MARK: - Preview

struct LandingHomeView_Previews: PreviewProvider {
    static var previews: some View {
        LandingHomeView()
    }
}
