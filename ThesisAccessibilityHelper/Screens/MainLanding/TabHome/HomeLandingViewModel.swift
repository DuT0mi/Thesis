//
//  HomeLandingViewModel.swift
//  ThesisAccessibilityHelper
//
//  Created by Dudas Tamas Alex on 2023. 10. 18..
//

import Foundation
import Resolver

@MainActor
final class HomeLandingViewModel: ObservableObject {
    // MARK: - Properties

    @LazyInjected private var speakerInstance: SynthesizerManager
    @LazyInjected private var profileInstance: TabProfileLandingViewModel
}

// MARK: - BaseViewModelInput

extension HomeLandingViewModel: BaseViewModelInput {
    func didAppear() {
        if profileInstance.interactiveMode {
            speakerInstance.speak(with: "Beléptél a főoldara")
        }
    }

    func didDisAppear() {
    }
}
