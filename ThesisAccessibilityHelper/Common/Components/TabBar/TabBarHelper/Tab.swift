//
//  Tab.swift
//  ThesisAccessibilityHelper
//
//  Created by Dudas Tamas Alex on 2023. 09. 09..
//

import Foundation

enum Tab: String, CaseIterable {
    case home = "Home"
    case services = "Services"
    case partners = "Partners"
    case activity = "Activity"

    var systemImage: String {
        switch self {
            case .home:
                return "house"
            case .services:
                return "bell"
            case .partners:
                return "pencil"
            case .activity:
                return "clock"
        }
    }

    var index: Int {
        return Tab.allCases.firstIndex(of: self) ?? 0
    }
}
