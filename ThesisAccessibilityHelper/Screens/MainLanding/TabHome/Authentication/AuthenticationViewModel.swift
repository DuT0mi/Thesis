//
//  AuthenticationViewModel.swift
//  ThesisAccessibilityHelper
//
//  Created by Dudas Tamas Alex on 2023. 10. 20..
//

import Foundation
import Resolver

// TODO: Request help if the user is the impared

/// Manages the authentication view ``AuthenticationView`` and getting data from the ``AuthenticationInteractor``
final class AuthenticationViewModel: ObservableObject {
    // MARK: - Types

    /// Response status of the authentication response, conform the **Equatable**
    /// - **Cases**:
    ///  - *none*: The default response
    ///  - *successful*: The successful response
    ///  - *signupSuccessfully*: The signupSuccessfully response
    ///  - *error*: The error response with the corresponding **error** as associated value
    enum AuthenticationResponseStatus: Equatable {
        // MARK: - Properties

        case none
        case successful
        case signupSuccessfully
        case error(Error)

        // MARK: - Equatable

        static func == (lhs: AuthenticationResponseStatus, rhs: AuthenticationResponseStatus) -> Bool {
            switch (lhs, rhs) {
                case (.none, .none),
                    (.successful, .successful),
                    (.signupSuccessfully, .signupSuccessfully):
                    return true
                case let (.error(error1), .error(error2)):
                    return error1.localizedDescription == error2.localizedDescription
                default:
                    return false
            }
        }
    }

    /// The User's possible account types
    /// - **Cases**
    ///  - *helper*: The helper, who helps the visually impared people on the Map (``TabMapLandingView``)
    ///  - *impared* The visually impared user, also can see the helpers and go to them (Request help is ongoing)
    enum AccountType: String {
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
    @LazyInjected private var firestoreDBInteractor: FireStoreDatabaseInteractor

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
        } catch {
            authenticationInteractor.saveAuthenticatedStatus(.error)
            alertMessage = error.localizedDescription
            authenticationStatus = .error(error)
        }
    }

    @MainActor
    private func login() async throws {
        do {
            try await authenticationInteractor.login(.init(email: email, password: password))
            self.isLoading.toggle()

            authenticationStatus = .successful
            authenticationInteractor.saveAuthenticatedStatus(.authenticated)

            NotificationCenter.default.post(Notification(name: .signedIn))

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
            let userDataResponse: AuthenticationDataResult = try await authenticationInteractor.createUser(.init(email: email, password: password))
            self.isLoading.toggle()
            self.createUser(userDataResponse)

            authenticationStatus = .signupSuccessfully
            authenticationInteractor.saveAuthenticatedStatus(.signupSuccessfully)
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

    private func resetCache() {
        authenticationStatus = .none
        email.removeAll()
        password.removeAll()
    }

    private func createUser(_ userDataResponse: AuthenticationDataResult) {
        Task(priority: .userInitiated) {
            switch self.selectedType {
                case .helper:
                    await firestoreDBInteractor.createUser(user: userFactory(userDataResponse, type: .helper))
                case .impared:
                    await firestoreDBInteractor.createUser(user: userFactory(userDataResponse, type: .impared))
            }

        }
    }

    private func userFactory(_ userDataResponse: AuthenticationDataResult, type: AccountType ) async -> UserModelInput {
        switch type {
            case .helper:
                return HelperUserModel(authenticationDataResult: userDataResponse)
            case .impared:
                return ImparedUserModel(authenticationDataResult: userDataResponse)
        }
    }
}

// MARK: - BaseViewModelInput

extension AuthenticationViewModel: BaseViewModelInput {
    func didAppear() {
        resetCache()
    }

    func didDisAppear() {
    }
}
