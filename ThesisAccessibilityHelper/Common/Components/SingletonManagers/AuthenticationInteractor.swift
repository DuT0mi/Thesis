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
        print("TEST | LOGIN")
        debugPrint(authDataResult)

        setCurrentUserID(authDataResult.user.uid)

        return .init(user: authDataResult.user)
    }

    @discardableResult
    func createUser(_ user: AuthenticationUserModel) async throws -> AuthenticationDataResult {
        let authDataResult = try await Auth.auth().createUser(withEmail: user.email, password: user.password)
        print("TEST | SIGN UP")
        debugPrint(authDataResult)

        setCurrentUserID(authDataResult.user.uid)

        return .init(user: authDataResult.user)
    }

    func signOut() throws {
        try Auth.auth().signOut()
    }

    private func setCurrentUserID(_ userID: String) {
        UserDefaults.standard.set(userID, forKey: UserKeys.currentUserID.rawValue)
    }
}
