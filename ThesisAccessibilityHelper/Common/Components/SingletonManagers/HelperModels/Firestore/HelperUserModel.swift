//
//  HelperUserModel.swift
//  ThesisAccessibilityHelper
//
//  Created by Dudas Tamas Alex on 2023. 10. 21..
//

import Foundation

struct HelperUserModel {
    // MARK: - Properties

    var userID: String
    var email: String?
    var dateCreated: Date?
    var type: AuthenticationViewModel.AccountType {
        get { .helper }
        set { }
    }

    // MARK: - Initialization

    init(userID: String, email: String? = nil, dateCreated: Date? = nil, type: AuthenticationViewModel.AccountType) {
        self.userID = userID
        self.email = email
        self.dateCreated = dateCreated
        self.type = type
    }

    init(authenticationDataResult: AuthenticationDataResult) {
        self.userID = authenticationDataResult.uid
        self.email = authenticationDataResult.email
        self.dateCreated = Date()
    }
}
// MARK: - CodingKeys

extension HelperUserModel {
    enum CodingKeys: String, CodingKey {
        case userID = "user_id"
        case email
        case dateCreated = "date_cerated"
        case type
    }
}

// MARK: - Codable

extension HelperUserModel: Codable {

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.userID = try container.decode(String.self, forKey: .userID)
        self.email = try container.decodeIfPresent(String.self, forKey: .email)
        self.dateCreated = try container.decodeIfPresent(Date.self, forKey: .dateCreated)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encode(self.userID, forKey: .userID)
        try container.encodeIfPresent(self.email, forKey: .email)
        try container.encodeIfPresent(self.dateCreated, forKey: .dateCreated)
        try container.encode(self.type.rawValue, forKey: .type)
    }
}

// MARK: - UserModelInput

extension HelperUserModel: UserModelInput {
}
