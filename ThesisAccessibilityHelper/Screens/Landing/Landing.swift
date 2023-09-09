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

    @State private var activeTab: Tab = .home // -> VM
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

                customTabBarFactory()
            }
        }
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
                .ignoresSafeArea()
                .shadow(color: activeTint.opacity(0.2), radius: 5, x: 0, y: -5)
                .blur(radius: 2)
                .padding(.top, 25)
        })
        .animation(.interactiveSpring(response: 0.6, dampingFraction: 0.7, blendDuration: 0.7), value: activeTab)
    }
}

struct Landing_Previews: PreviewProvider {
    static var previews: some View {
        Landing()
            .environment(\.locale, .init(identifier: Locales.en.rawValue))
    }
}
