//
//  TabMapLandingViewModel.swift
//  ThesisAccessibilityHelper
//
//  Created by Dudas Tamas Alex on 2023. 10. 21..
//

import Foundation
import Resolver

@MainActor
final class TabMapLandingViewModel: ObservableObject {
    // MARK: - Properties

    @LazyInjected private var tabHosterInstance: TabHosterViewViewModel

    // MARK: - Functions
}

extension TabMapLandingViewModel: BaseViewModelInput {
    func didAppear() {
        tabHosterInstance.tabBarStatus.send(.hide)
    }

    func didDisAppear() {
        tabHosterInstance.tabBarStatus.send(.show)
    }
}
