//
//  AuthenticationViewModel.swift
//  ThesisAccessibilityHelper
//
//  Created by Dudas Tamas Alex on 2023. 10. 20..
//

import Foundation
import Resolver

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
    @Published var selectedType: AccountType = .impared
    @Published var alertMessage = String()
    @Published var alert = false
    @Published var authenticationStatus: AuthenticationResponseStatus = .none
    @Published private(set) var isLoading = false
    @Published private(set) var isAuthenticated = false

    @LazyInjected private var authenticationInteractor: AuthenticationInteractor

    // MARK: - Initialization

    init() {
    }

    // MARK: - Functions

    @MainActor
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
                    try await performOperation(login)
                }
            case .signup:
                Task {
                    try await performOperation(signup)
                }
            @unknown default:
                break
        }
    }

    @MainActor
    private func performOperation(_ operation: () async throws -> Void) async rethrows {
        defer {
            authenticationInteractor.encodeAuthenticatedStatus { [weak self] result in
                self?.isAuthenticated = result
            }
        }

        do {
            try await operation()
            authenticationStatus = .successful
            authenticationInteractor.saveAuthenticatedStatus(.authenticated)
        } catch {
            authenticationInteractor.saveAuthenticatedStatus(.notAuthenticated)
            alertMessage = error.localizedDescription
            authenticationStatus = .error(error)
        }
    }

    @MainActor
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

    @MainActor
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

    @MainActor
    private func showAlertMessage(_ alertMessage: String) {
        self.alertMessage = alertMessage
        alert.toggle()
    }

    @MainActor
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
