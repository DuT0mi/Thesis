//
//  Tab.swift
//  ThesisAccessibilityHelper
//
//  Created by Dudas Tamas Alex on 2023. 09. 09..
//

import Foundation

enum Tab: String, CaseIterable {
    case home = "Home"
    case menu = "Menu"
    case profile = "Profile"

    var systemImage: String {
        switch self {
            case .home:
                return "house.and.flag"
            case .menu:
                return "circle.grid.cross.up.filled"
            case .profile:
                return "gear"
        }
    }

    var index: Int {
        return Tab.allCases.firstIndex(of: self) ?? 0
    }
}

enum TabBarStatus {
    case show
    case hide
}
