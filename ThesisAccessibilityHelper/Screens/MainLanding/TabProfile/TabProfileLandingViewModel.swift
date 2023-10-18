//
//  TabProfileLandingViewModel.swift
//  ThesisAccessibilityHelper
//
//  Created by Dudas Tamas Alex on 2023. 10. 15..
//

import Foundation
import SwiftUI
import Resolver

final class TabProfileLandingViewModel: ObservableObject {
    // MARK: - Types

    private struct Consts {
        static let defaultRefreshTime: Int = -1
    }

    // MARK: - Properties

    @AppStorage("interactiveMode") var interactiveMode = false
    @AppStorage("objectDetectRefreshData") var objectDetectRefreshData: Int = Consts.defaultRefreshTime
    @AppStorage("objectDetectLanguage") var objectDetectLanguage = TabProfileLandingView.CountryCode.hun.rawValue

    @LazyInjected private var speakerInstance: SynthesizerManager

    // MARK: - Intent(s)

    func setInteractiveMode(_ newValue: Bool) {
        interactiveMode = newValue
    }

    func setRefreshTime(_ newValue: Int) {
        objectDetectRefreshData = newValue
    }

    func setCountryCode(_ newValue: TabProfileLandingView.CountryCode) {
        objectDetectLanguage = newValue.rawValue
    }
}

// MARK: - BaseViewModelInput

extension TabProfileLandingViewModel: BaseViewModelInput {
    func didAppear() {
        if interactiveMode {
            speakerInstance.speak(with: "Beléptél a Profil menüpontba")
        }
    }

    func didDisAppear() {
    }
}
