//
//  TabHomeLandingView.swift
//  ThesisAccessibilityHelper
//
//  Created by Dudas Tamas Alex on 2023. 09. 15..
//

import SwiftUI

/// The  Home view
struct TabHomeLandingView: View {
    // MARK: - Types

    struct Consts {
        struct Image {
            static let leading = "info.circle"
            static let trailing = "person.fill.questionmark"
            static let trailingAuthenticated = "person.fill.checkmark"

            static let size: CGFloat = 28
            static let spacing: CGFloat = 16
        }
    }

    // MARK: - Properties

    @EnvironmentObject var demoModelData: DemoData
    @StateObject private var viewModel = HomeLandingViewModel()
    @StateObject private var authViewModel = AuthenticationViewModel()
    @State private var showInfo = false
    @State private var showAuth = false

    var body: some View {
        NavigationView {
            BaseView {
                VStack {
                    PageView(pages: demoModelData.demoItems!.compactMap {
                        CardView(demoCard: $0)
                            .scrollClipDisabled(true)
                    })
                    .aspectRatio(3 / 2, contentMode: .fit)
                    Spacer()
                    HStack(spacing: Consts.Image.spacing) {
                        RectangleView(systemName: Consts.Image.leading) {
                            showInfo.toggle()
                        }
                        .accessibilityLabel("Info button")
                        .accessibilityHint("Tap for open the info")
                        .accessibilityAddTraits(.isButton)

                        if viewModel.isAuthenticated {
                            RectangleView(systemName: Consts.Image.trailingAuthenticated, isLogged: viewModel.isAuthenticated)
                                .accessibilityLabel("Authentication button")
                                .accessibilityHint("Tap for open authentication")
                                .accessibilityValue(!viewModel.isAuthenticated ? "is available" : "is not available")
                                .accessibilityAddTraits(.isButton)
                        } else {
                            RectangleView(systemName: Consts.Image.trailing) {
                                showAuth.toggle()
                            }
                            .accessibilityHint("Tap for open the authentication")
                            .accessibilityValue(!viewModel.isAuthenticated ? "is available" : "is not available")
                            .accessibilityAddTraits(.isButton)
                        }
                    }
                    Spacer()
                }
            }
        }
        .ignoresSafeArea()
        .sheet(isPresented: $showInfo) {
            HomeInfoView()
                .sheetStyle(style: .mixed, dismissable: true, showIndicator: true)
        }
        .sheet(isPresented: $showAuth) {
            AuthenticationView(viewModel: authViewModel, type: .login)
                .sheetStyle(style: .large, dismissable: true, showIndicator: true)
        }
        .task {
            await viewModel.loadData()
        }
        .onAppear {
            viewModel.didAppear()
        }
    }
}

// MARK: - PreviewProvider

struct TabHomeLandingView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            TabHomeLandingView()
        }
    }
}
