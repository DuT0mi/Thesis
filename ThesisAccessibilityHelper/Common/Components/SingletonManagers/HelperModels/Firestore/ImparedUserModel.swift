//
//  ImparedUserModel.swift
//  ThesisAccessibilityHelper
//
//  Created by Dudas Tamas Alex on 2023. 10. 21..
//

import Foundation

struct ImparedUserModel {
    // MARK: - Properties

    var userID: String
    var email: String?
    var dateCreated: Date?
    var latitude: Double?
    var longitude: Double?
    var type: AuthenticationViewModel.AccountType {
        get { .impared }
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

extension ImparedUserModel {
    enum CodingKeys: String, CodingKey {
        case userID = "user_id"
        case email
        case dateCreated = "date_cerated"
        case type
        case latitude
        case longitude
    }
}

// MARK: - Codable

extension ImparedUserModel: Codable {

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.userID = try container.decode(String.self, forKey: .userID)
        self.email = try container.decodeIfPresent(String.self, forKey: .email)
        self.dateCreated = try container.decodeIfPresent(Date.self, forKey: .dateCreated)
        self.latitude = try container.decodeIfPresent(Double.self, forKey: .latitude)
        self.longitude = try container.decodeIfPresent(Double.self, forKey: .longitude)
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

extension ImparedUserModel: UserModelInput {
}
