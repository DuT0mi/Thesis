//
//  AuthenticationUserModel.swift
//  ThesisAccessibilityHelper
//
//  Created by Dudas Tamas Alex on 2023. 10. 20..
//

import Foundation

/// A model that represent a user via the authentication flow
/// - Parameters:
///    - email: Email
///    - password: Without any hash (Firebase do the work)
struct AuthenticationUserModel {
    var email: String
    var password: String
}
