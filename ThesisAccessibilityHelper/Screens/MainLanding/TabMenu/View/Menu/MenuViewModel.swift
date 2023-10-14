//
//  MenuViewModel.swift
//  ThesisAccessibilityHelper
//
//  Created by Dudas Tamas Alex on 2023. 09. 15..
//

import Foundation
import Resolver

protocol MenuViewModelInput: BaseViewModelInput {
    func didTapItem()
}

@MainActor
final class MenuViewModel: ObservableObject {
    // MARK: - Properties

    @Injected private var tabHosterInstance: TabHosterViewViewModel
}

// MARK: - ObjectDetectViewModelInput

extension MenuViewModel: ObjectDetectViewModelInput {
    func didAppear() {
        tabHosterInstance.tabBarStatus.send(.hide)
    }

    func didDisAppear() {
        tabHosterInstance.tabBarStatus.send(.show)
    }

    func didTapItem() {
        tabHosterInstance.tabBarStatus.send(.hide)
    }
}
