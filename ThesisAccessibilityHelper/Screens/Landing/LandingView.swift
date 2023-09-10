//
//  ContentView.swift
//  ThesisAccessibilityHelper
//
//  Created by Dudas Tamas Alex on 2023. 09. 08..
//

import SwiftUI

struct Landing: View {
    // MARK: - Properties

    @Namespace private var animation

    @StateObject private var viewModel = LandingViewModel()

    @State private var activeTab: Tab = .home // TODO: -> VM
    @State private var tabShapePosition: CGPoint = .zero

    var body: some View {
        BaseView {
            VStack {
                TabView(selection: $activeTab) {
                    LandingHomeView()
                        .tag(Tab.home)

                    AuthenticationLandingView()
                        .tag(Tab.services)

                    DemoLandingView()
                        .tag(Tab.partners)

                    Text(Localized.helloWorld)
                        .tag(Tab.activity)
                }

                if viewModel.shouldShowTabBar {
                    customTabBarFactory()
                }
            }
        }
        .environmentObject(viewModel)
        .ignoresSafeArea()
    }

    // MARK: - Initialization

    init() {
        // Required of iOS 16 bug (text is moving when chaning tabs)
        UITabBar.appearance().isHidden = true
    }

    // MARK: - Functions

    @ViewBuilder
    func customTabBarFactory(_ activeTint: Color = .blue, _ inactiveTint: Color = .black) -> some View {
        HStack(alignment: .bottom) {
            ForEach(Tab.allCases, id: \.rawValue) {
                TabItem(
                    tint: activeTint,
                    inactiveTint: inactiveTint,
                    tab: $0,
                    animation: animation,
                    activeTab: $activeTab,
                    position: $tabShapePosition
                )
            }
        }
        .padding()
        .background(content: {
            TabShape(midPoint: tabShapePosition.x)
                .fill(.gray.opacity(0.5))
                .shadow(color: activeTint.opacity(0.2), radius: 5, x: 0, y: -5)
                .blur(radius: 2)
                .padding(.top, 30)
        })
        .animation(.interactiveSpring(response: 0.6, dampingFraction: 0.7, blendDuration: 0.7), value: activeTab)
    }
}

// MARK: - Preview

struct Landing_Previews: PreviewProvider {
    static var previews: some View {
        Landing()
            .environment(\.locale, .init(identifier: Locales.en.rawValue))
    }
}