//
//  UserModelInput.swift
//  ThesisAccessibilityHelper
//
//  Created by Dudas Tamas Alex on 2023. 10. 21..
//

import Foundation

protocol UserModelInput {
    var userID: String { get set }
    var email: String? { get set }
    var dateCreated: Date? { get set }
    var latitude: Double? { get set }
    var longitude: Double? { get set }
    var type: AuthenticationViewModel.AccountType { get }
}
