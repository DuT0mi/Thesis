//
//  AuthenticationViewModel.swift
//  ThesisAccessibilityHelper
//
//  Created by Dudas Tamas Alex on 2023. 10. 20..
//

import Foundation
import Resolver

@MainActor
final class AuthenticationViewModel: ObservableObject {
    // MARK: - Types

    enum AuthenticationResponseStatus: Equatable {
        // MARK: - Properties

        case none
        case successful
        case error(Error)

        // MARK: - Equatable

        static func == (lhs: AuthenticationResponseStatus, rhs: AuthenticationResponseStatus) -> Bool {
            switch (lhs, rhs) {
                case (.none, .none):
                    return true
                case (.successful, .successful):
                    return true
                case let (.error(error1), .error(error2)):
                    return error1.localizedDescription == error2.localizedDescription
                default:
                    return false
            }
        }
    }

    enum AccountType {
        case helper
        case impared
    }

    // MARK: - Properties

    @Published var email = String()
    @Published var password = String()
    @Published var selectedType: AccountType
    @Published var alertMessage = String()
    @Published var alert = false
    @Published var authenticationStatus: AuthenticationResponseStatus = .none
    @Published private(set) var isLoading = false

    @LazyInjected private var authenticationInteractor: AuthenticationInteractor

    // MARK: - Initialization

    init() {
        _selectedType = .init(initialValue: .impared)
    }

    // MARK: - Functions

    func didTapButton(with type: AuthenticationView.Page) {
        isLoading.toggle()

        guard !email.isEmpty || !password.isEmpty else {
            showAlertMessage("Neither email nor password can be empty.")
            isLoading.toggle()

            return
        }

        switch type {
            case .login:
                Task {
                    do {
                        try await login()
                        authenticationStatus = .successful
                    } catch {
                        alertMessage = error.localizedDescription
                        authenticationStatus = .error(error)
                    }
                }
            case .signup:
                Task {
                    do {
                        try await signup()
                        authenticationStatus = .successful
                    } catch {
                        alertMessage = error.localizedDescription
                        authenticationStatus = .error(error)
                    }
                }
            @unknown default:
                break
        }
    }

    private func login() async throws {
        do {
            try await authenticationInteractor.login(.init(email: email, password: password))
            self.isLoading.toggle()
            resetCache()
        } catch {
            self.alertMessage = error.localizedDescription
            self.alert.toggle()
            self.isLoading.toggle()
        }

    }

    private func signup() async throws {
        do {
            try await authenticationInteractor.createUser(.init(email: email, password: password))
            self.isLoading.toggle()
            /* create and save account here ... */ // TODO: ...
            resetCache()
        } catch {
            self.alertMessage = error.localizedDescription
            self.alert.toggle()
            self.isLoading.toggle()
        }
    }

    private func showAlertMessage(_ alertMessage: String) {
        self.alertMessage = alertMessage
        alert.toggle()
    }

    private func resetCache() {
        authenticationStatus = .none
    }
}

// MARK: - BaseViewModelInput

extension AuthenticationViewModel: BaseViewModelInput {
    func didAppear() {
    }

    func didDisAppear() {
    }
}
