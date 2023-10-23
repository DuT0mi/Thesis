//
//  AuthenticationDataResult.swift
//  ThesisAccessibilityHelper
//
//  Created by Dudas Tamas Alex on 2023. 10. 20..
//

import Foundation
import FirebaseAuth

/// A model that represent a user after the authentication flow, as a response
/// - Parameters:
///  - uid: The user's ID
///  - email: The user's email
///  - photoURL: The user's photoURL
///  - description: A textual representation of the receiver
///  - additionalUserInfo: For more information see `FIRAdditionalUserInfo`
///  - credential: For more information see `FIRAuthCredential`
struct AuthenticationDataResult {
    // MARK: - Properties

    var uid: String
    var email: String?
    var photoURL: String?
    var description: String?
    var additionalUserInfo: AdditionalUserInfo?
    var credential: AuthCredential?

    // MARK: - Initialization

    init(user: User, additionalUserInfo: AdditionalUserInfo? = nil, credential: AuthCredential? = nil) {
        self.uid = user.uid
        self.email = user.email
        self.photoURL = user.photoURL?.absoluteString
        self.description = user.description
        self.additionalUserInfo = additionalUserInfo
        self.credential = credential
    }

    init?(user: User?, additionalUserInfo: AdditionalUserInfo? = nil, credential: AuthCredential? = nil) {
        guard let user else { return nil }

        self.uid = user.uid
        self.email = user.email
        self.photoURL = user.photoURL?.absoluteString
        self.description = user.description
        self.additionalUserInfo = additionalUserInfo
        self.credential = credential
    }
}
