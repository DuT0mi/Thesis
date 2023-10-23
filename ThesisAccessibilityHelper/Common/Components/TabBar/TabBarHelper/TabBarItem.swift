//
//  TabBarItem.swift
//  ThesisAccessibilityHelper
//
//  Created by Dudas Tamas Alex on 2023. 09. 09..
//

import SwiftUI

struct TabItem: View {
    // MARK: - Properties

    var tint: Color
    var inactiveTint: Color
    var tab: Tab
    var animation: Namespace.ID

    @Binding var activeTab: Tab
    @Binding var position: CGPoint

    @State private var tabPos: CGPoint = .zero

    var body: some View {
        VStack(spacing: 5) {
            Image(systemName: tab.systemImage)
                .font(.title2)
                .foregroundColor(activeTab == tab ? .white : inactiveTint)
                .frame(width: activeTab == tab ? 50 : 30, height: activeTab == tab ? 50 : 30)
                .background {
                    if activeTab == tab {
                        Circle()
                            .fill(tint.gradient)
                            .matchedGeometryEffect(id: "ACTIVE", in: animation)
                    }
                }
//            Text(tab.rawValue)
//                .font(.caption)
//                .foregroundColor(activeTab == tab ? tint : .gray)
        }
        .frame(maxWidth: .infinity)
        .contentShape(Rectangle())
        .viewPosition(completion: { rect in
            tabPos.x = rect.midX

            if activeTab == tab {
                position.x = rect.midX
            }
        })
        .onTapGesture {
            activeTab = tab

            withAnimation(.interactiveSpring(response: 0.6, dampingFraction: 0.7, blendDuration: 0.7)) {
                position.x = tabPos.x
            }
        }
    }
}
