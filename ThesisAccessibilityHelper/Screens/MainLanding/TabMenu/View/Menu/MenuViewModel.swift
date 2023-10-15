//
//  MenuViewModel.swift
//  ThesisAccessibilityHelper
//
//  Created by Dudas Tamas Alex on 2023. 09. 15..
//

import Foundation
import Resolver

protocol MenuViewModelInput: BaseViewModelInput {
    func hideTabBar()
    func didTapMenuItem(on menuItemType: MenuViewModel.MenuItemType)
}

@MainActor
final class MenuViewModel: ObservableObject {
    // MARK: - Types

    enum MenuItemType {
        case objectDetect
        case scan
        case map
        case storage
        case `self`
    }

    // MARK: - Properties

    @Injected private var tabHosterInstance: TabHosterViewViewModel
    @Injected private var tabProfileInstance: TabProfileLandingViewModel
    @Injected private var synthesizerManager: SynthesizerManager

    // MARK: - Functions

    private func generateString(for item: MenuItemType) -> String {
        switch item {
            case .objectDetect:
                return "Beléptél az objektum detektálás funkcióba"
            case .scan:
                return "Beléptél az szkennelés funkcióba"
            case .map:
                return "Beléptél a térkép funkcióba"
            case .storage:
                return "Beléptél a fótók funkcióba"
            default:
                return "Beléptél a menübe"
        }
    }
}

// MARK: - ObjectDetectViewModelInput

extension MenuViewModel: ObjectDetectViewModelInput {
    func didAppear() {
        tabHosterInstance.tabBarStatus.send(.hide)
    }

    func didDisAppear() {
        tabHosterInstance.tabBarStatus.send(.show)
    }

    func hideTabBar() {
        tabHosterInstance.tabBarStatus.send(.hide)
    }

    func didTapMenuItem(on menuItemType: MenuViewModel.MenuItemType) {
        DispatchQueue.global(qos: .userInitiated).async {
            if self.tabProfileInstance.interactiveMode {
                self.synthesizerManager.speak(with: self.generateString(for: menuItemType))
            }
        }
    }
}
