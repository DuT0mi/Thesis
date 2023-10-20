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
    @AppStorage("objectDetectRefreshData") var objectDetectRefreshData = Consts.defaultRefreshTime
    @AppStorage("objectDetectLanguage") var objectDetectLanguage = TabProfileLandingView.CountryCode.hun.rawValue

    @Published var currentUser: AuthenticationDataResult?
    @Published var isAuthenticated = false

    @Published private var cachedUser: AuthenticationDataResult?

    @LazyInjected private var speakerInstance: SynthesizerManager
    @LazyInjected private var authenticationInteractor: AuthenticationInteractor

    // MARK: - Initialization

    init() {
        addSubscribers()
        addObservers()
    }

    // MARK: - Functions

    @MainActor
    func signout() {
        do {
            try authenticationInteractor.signOut()
            self.resetCache()
        } catch {
            print("TODO: \(error.localizedDescription)")
        }
    }

    @MainActor
    func loadData() async {
        authenticationInteractor.encodeAuthenticatedStatus { [weak self] result in
            self?.isAuthenticated = result
        }
    }

    @MainActor
    private func getCurrentUser() {
        if let cachedUser {
            currentUser = cachedUser

            return
        }

        authenticationInteractor.getCurrentUser { [weak self] result in
            switch result {
                case .success(let currentUser):
                    self?.currentUser = currentUser
                case .failure:
                    self?.currentUser?.uid = AuthenticationError.userIsNotAuthenticated.failureReason ?? "Error at\(#function)"
            }
        }
    }

    private func addSubscribers() {
        $currentUser
            .receive(on: RunLoop.main)
            .dropFirst()
            .assign(to: &$cachedUser)
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

    private func resetCache() {
        cachedUser = nil
    }

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

        Task {
            await getCurrentUser()
        }
    }

    func didDisAppear() {
    }
}
