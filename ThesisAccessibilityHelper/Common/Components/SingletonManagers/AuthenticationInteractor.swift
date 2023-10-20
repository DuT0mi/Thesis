//
//  AuthenticationInteractor.swift
//  ThesisAccessibilityHelper
//
//  Created by Dudas Tamas Alex on 2023. 10. 20..
//

import Foundation
import FirebaseAuth
import Resolver

@MainActor
final class AuthenticationInteractor {
    // MARK: - Types

    enum AuthenticationState: String, RawRepresentable {
        case authenticated
        case notAuthenticated
    }

    // MARK: - Properties

    static let shared = AuthenticationInteractor()

    @LazyInjected private var fireStoreInteractor: FireStoreDatabaseInteractor

    // MARK: - Initialization

    private init() {
    }

    // MARK: - Functions

    @discardableResult
    func login(_ user: AuthenticationUserModel) async throws -> AuthenticationDataResult {
        let authDataResult = try await Auth.auth().signIn(withEmail: user.email, password: user.password)

        setCurrentUserID(authDataResult.user.uid)

        return userMapper(authDataResult)
    }

    @discardableResult
    func createUser(_ user: AuthenticationUserModel) async throws -> AuthenticationDataResult {
        let authDataResult = try await Auth.auth().createUser(withEmail: user.email, password: user.password)

        setCurrentUserID(authDataResult.user.uid)

        return userMapper(authDataResult)
    }

    func signOut() throws {
        try Auth.auth().signOut()
        saveAuthenticatedStatus(.notAuthenticated)
    }

    func getCurrentUser(completion: @escaping (Result<AuthenticationDataResult, Error>) -> Void) {
        guard let user = Auth.auth().currentUser else {
            completion(.failure(AuthenticationError.userIsNotAuthenticated))

            return
        }

        completion(.success(.init(user: user)))
    }

    func saveAuthenticatedStatus(_ state: AuthenticationState) {
        UserDefaults.standard.set(state.rawValue, forKey: UserKeys.authenticationKey.rawValue)

        NotificationCenter.default.post(Notification(name: .authenticatedStatusDidChange))
    }

    func encodeAuthenticatedStatus(completion: @escaping (Bool) -> Void) {
        guard let state = AuthenticationState(rawValue: UserDefaults.standard.string(forKey: UserKeys.authenticationKey.rawValue) ?? "") else {
            completion(false)

            return
        }

        switch state {
            case .authenticated:
                completion(true)
            case .notAuthenticated:
                completion(false)
        }

    }

    private func setCurrentUserID(_ userID: String) {
        UserDefaults.standard.set(userID, forKey: UserKeys.currentUserID.rawValue)
    }

    private func userMapper(_ authDataRes: AuthDataResult) -> AuthenticationDataResult {
        AuthenticationDataResult.init(
            user: authDataRes.user,
            additionalUserInfo: authDataRes.additionalUserInfo,
            credential: authDataRes.credential
        )
    }
}
