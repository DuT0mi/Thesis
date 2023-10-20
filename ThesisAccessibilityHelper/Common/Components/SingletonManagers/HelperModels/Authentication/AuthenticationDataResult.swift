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
struct AuthenticationDataResult {
    // MARK: - Properties

    let uid: String
    let email: String?
    let photoURL: String?

    // MARK: - Initialization

    init(user: User) {
        self.uid = user.uid
        self.email = user.email
        self.photoURL = user.photoURL?.absoluteString
    }
}
