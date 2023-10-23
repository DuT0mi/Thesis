//
//  HomeLandingViewModel.swift
//  ThesisAccessibilityHelper
//
//  Created by Dudas Tamas Alex on 2023. 10. 18..
//

import Foundation
import Resolver

/// Manages the ``TabHomeLandingView``
@MainActor
final class HomeLandingViewModel: ObservableObject {
    // MARK: - Properties

    @Published private(set) var isAuthenticated = false

    @LazyInjected private var speakerInstance: SynthesizerManager
    @LazyInjected private var profileInstance: TabProfileLandingViewModel
    @LazyInjected private var authenticationInteractor: AuthenticationInteractor

    // MARK: - Initialization

    init() {
        addObservers()
    }

    // MARK: - Functions

    func loadData() async {
        authenticationInteractor.encodeAuthenticatedStatus { [weak self] result in
            self?.isAuthenticated = result
        }
    }

    private func addObservers() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(authenticatedStatusDidChangeHandler),
            name: .authenticatedStatusDidChange,
            object: nil
        )
    }

    @objc func authenticatedStatusDidChangeHandler() {
        Task(priority: .high) {
            await self.loadData()
        }
    }
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
