//
//  TabProfileLandingViewModel.swift
//  ThesisAccessibilityHelper
//
//  Created by Dudas Tamas Alex on 2023. 10. 15..
//

import Foundation
import SwiftUI

final class TabProfileLandingViewModel: ObservableObject {
    // MARK: - Types

    private struct Consts {
        static let defaultRefreshTime: Int = -1
    }

    // MARK: - Properties

    @AppStorage("interactiveMode") var interactiveMode = false
    @AppStorage("objectDetectRefreshData") var objectDetectRefreshData: Int = Consts.defaultRefreshTime
    @AppStorage("objectDetectLanguage") var objectDetectLanguage = TabProfileLandingView.CountryCode.hun.rawValue

    // MARK: - Intent(s)

    func setInteractiveMode(_ newValue: Bool) {
        interactiveMode = newValue
    }

    func setRefreshTime(_ newValue: Int) {
        objectDetectRefreshData = newValue
    }

    func setCountryCode(_ newValue: TabProfileLandingView.CountryCode) {
        objectDetectLanguage = newValue.rawValue
        // TODO: Object detect dict
    }
}