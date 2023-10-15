//
//  TabProfileLandingViewModel.swift
//  ThesisAccessibilityHelper
//
//  Created by Dudas Tamas Alex on 2023. 10. 15..
//

import Foundation
import SwiftUI

final class TabProfileLandingViewModel: ObservableObject {
    // MARK: - Properties

    @AppStorage("interactiveMode") var interactiveMode = false

    // MARK: - Intent(s)

    func setInteractiveMode(_ newValue: Bool) {
        interactiveMode = newValue
    }
}
