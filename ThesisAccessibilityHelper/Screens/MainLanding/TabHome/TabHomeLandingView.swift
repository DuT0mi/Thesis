//
//  TabHomeLandingView.swift
//  ThesisAccessibilityHelper
//
//  Created by Dudas Tamas Alex on 2023. 09. 15..
//

import SwiftUI

struct TabHomeLandingView: View {
    // MARK: - Properties

    @StateObject private var viewModel = HomeLandingViewModel()

    var body: some View {
        BaseView {
            Text("Home Landing")
        }
        .onAppear {
            viewModel.didAppear()
        }
        .ignoresSafeArea()
    }
}

struct TabHomeLandingView_Previews: PreviewProvider {
    static var previews: some View {
        TabHomeLandingView()
    }
}
