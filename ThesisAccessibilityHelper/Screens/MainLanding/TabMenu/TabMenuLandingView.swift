//
//  TabMenuLandingView.swift
//  ThesisAccessibilityHelper
//
//  Created by Dudas Tamas Alex on 2023. 09. 15..
//

import SwiftUI
import Resolver

struct TabMenuLandingView: View {
    // MARK: - Properties

    @StateObject private var viewModel = TabMenuLandingViewModel()

    var body: some View {
        BaseView {
            NotAuthenticatedView()
                .zIndex(viewModel.isAuthenticated ? 0 : 1)
            MenuView()
                .allowsHitTesting(viewModel.isAuthenticated ? true : false)
        }
        .task {
            await viewModel.loadData()
        }
        .ignoresSafeArea()
    }
}

struct TabMenuLandingView_Previews: PreviewProvider {
    static var previews: some View {
        TabMenuLandingView()
    }
}
