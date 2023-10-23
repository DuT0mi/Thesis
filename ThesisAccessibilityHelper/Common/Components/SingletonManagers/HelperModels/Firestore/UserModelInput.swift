//
//  UserModelInput.swift
//  ThesisAccessibilityHelper
//
//  Created by Dudas Tamas Alex on 2023. 10. 21..
//

import Foundation

/// A Model that describes a behaviour for the  XY typed User, being uplodaded and downloaded from the **FireBase server**
/// - Parameters:
///  - userID: The User's ID
///  - email: The User's email
///  - dateCreated: The date when the User's profiel was created
///  - latitude: The User's latitude coordinate
///  - longitude: The User's longitude coordinate
///  - type: The User's type, for more information see: ``AuthenticationViewModel``
protocol UserModelInput {
    var userID: String { get set }
    var email: String? { get set }
    var dateCreated: Date? { get set }
    var latitude: Double? { get set }
    var longitude: Double? { get set }
    var type: AuthenticationViewModel.AccountType { get }
}
