//
//  TabHomeLandingView.swift
//  ThesisAccessibilityHelper
//
//  Created by Dudas Tamas Alex on 2023. 09. 15..
//

import SwiftUI

struct TabHomeLandingView: View {
    // MARK: - Types

    struct Consts {
        struct Image {
            static let leading = "info.circle"
            static let trailing = "person.fill.questionmark"

            static let size: CGFloat = 28
            static let spacing: CGFloat = 16
        }
    }

    // MARK: - Properties

    @StateObject private var viewModel = HomeLandingViewModel()
    @State private var showInfo = false
    @State private var showAuth = false

    var body: some View {
        NavigationView {
            BaseView {
                VStack {
                    Spacer()
                    HStack(spacing: Consts.Image.spacing) {
                        RectangleView(systemName: Consts.Image.leading) {
                            showInfo.toggle()
                        }
                        RectangleView(systemName: Consts.Image.trailing) {
                            showAuth.toggle()
                        }
                    }
                    Spacer()
                }
            }
        }
        .sheet(isPresented: $showInfo) {
            HomeInfoView()
                .sheetStyle(style: .mixed, dismissable: true, showIndicator: true)
        }
        .sheet(isPresented: $showAuth) {
            AuthenticationView(type: .login)
                .sheetStyle(style: .large, dismissable: true, showIndicator: true)
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
