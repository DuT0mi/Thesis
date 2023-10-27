//
//  AuthenticationInteractor.swift
//  ThesisAccessibilityHelper
//
//  Created by Dudas Tamas Alex on 2023. 10. 20..
//

import Foundation
import FirebaseAuth
import Resolver
import UIKit

/// The interactor layer for the Authentication flow
@MainActor
final class AuthenticationInteractor {
    // MARK: - Types 

    /// The authentication state's for the current corresponding User
    /// - **Cases**:
    ///  - *authenticated*: Authenticated state
    ///  - *notAuthenticated*: Not authenticated state
    ///  - *signupSuccessfully*: Sign up successfully, for showing popup view : ``PopupView``
    ///  - *`default`* :The default state
    ///  - *error*: The error state
    enum AuthenticationState: String, RawRepresentable {
        case authenticated
        case notAuthenticated
        case signupSuccessfully
        case `default`
        case error
    }

    // MARK: - Properties

    static let shared = AuthenticationInteractor()

    @LazyInjected private var fireStoreDBInteractor: FireStoreDatabaseInteractor
    @LazyInjected private var tabMapLandingVM: TabMapLandingViewModel

    // swiftlint: disable identifier_name
    private(set) var _authenticationDataResult: AuthenticationDataResult?
    // swiftlint: enable identifier_name

    // MARK: - Initialization

    private init() {
        addObservers()
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

        return userMapper(authDataResult)
    }

    func signOut() throws {
        try Auth.auth().signOut()
        saveAuthenticatedStatus(.default)
        resetDefaults()
    }

    func getCurrentUser(completion: @escaping (Result<AuthenticationDataResult, Error>) -> Void) {
        guard let user = Auth.auth().currentUser else {
            completion(.failure(AuthenticationError.userIsNotAuthenticated))

            return
        }

        completion(.success(.init(user: user)))
    }

    func getCurrentUser() -> AuthenticationDataResult? {
        AuthenticationDataResult(user: Auth.auth().currentUser) ?? (_authenticationDataResult ?? nil)
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
            default:
                completion(false)
        }

    }

    // swiftlint: disable identifier_name
    @objc func handleDelegateNotification() {
        getCurrentUser { [weak self] result in
            guard case .success(let authDataRes) = result else {
                return
            }
            self?._authenticationDataResult = authDataRes
        }
        Task {
            guard let _authenticationDataResult, let loc = tabMapLandingVM.currentUserLocation else { return }
            await fireStoreDBInteractor.updateCoordinates(for: _authenticationDataResult, coordinates: (loc.latitude, loc.longitude))
            print("TEST | DATA RES: \(_authenticationDataResult), LOC: \(loc)")
        }
    }
    // swiftlint: enable identifier_name

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

    private func resetDefaults() {
        let defaults = UserDefaults.standard
        let dictionary = defaults.dictionaryRepresentation()
        dictionary.keys.forEach { key in
            defaults.removeObject(forKey: key)
        }
        defaults.synchronize()
    }

    private func addObservers() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleDelegateNotification),
            name: UIApplication.didBecomeActiveNotification,
            object: nil
        )

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleDelegateNotification),
            name: .signedIn,
            object: nil
        )
    }
}
