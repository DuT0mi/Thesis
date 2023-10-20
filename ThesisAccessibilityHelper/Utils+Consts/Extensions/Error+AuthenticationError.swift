//
//  Error+AuthenticationError.swift
//  ThesisAccessibilityHelper
//
//  Created by Dudas Tamas Alex on 2023. 10. 20..
//

import Foundation

enum AuthenticationError: Error, LocalizedError {
    case userIsNotAuthenticated

    var errorDescription: String? {
        switch self {
            case .userIsNotAuthenticated:
                return NSLocalizedString("User is not authenticated", comment: "\(#file)")
        }
    }

    var failureReason: String? {
        switch self {
            case .userIsNotAuthenticated:
                return NSLocalizedString("The user is not authenticated. Please log in to access this feature.", comment: "\(#file)")
        }
    }
}
