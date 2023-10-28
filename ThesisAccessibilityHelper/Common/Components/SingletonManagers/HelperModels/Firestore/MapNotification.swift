//
//  Notification.swift
//  ThesisAccessibilityHelper
//
//  Created by Dudas Tamas Alex on 2023. 10. 28..
//

import Foundation

/// A Model that describes a notification between the users
/// - Parameters:
///  - notificationID: The ID of the notification
///  - date: The date when the notification has been created
///  - senderID: The sender of the notification
///  - receiverID: The receiver
///  - didSent: The receiver did get the notification
///  - etaExpectedTravelTime: Expected travel time in seconds
///  - etaDistance: Expected travel distance in meters
struct MapNotification {
    // MARK: - Properties

    var notificationID: String
    var date: Date?
    var senderID: String?
    var receiverID: String?
    var didSent: Bool?
    var etaExpectedTravelTime: Double?
    var etaDistance: Double?
    var etaExpectedArrivalDate: Date?

    // MARK: - Initialization

    init(notificationID: String, date: Date? = nil, senderID: String? = nil, receiverID: String? = nil, didSent: Bool? = nil, etaExpectedTravelTime: Double? = nil, etaDistance: Double? = nil, etaExpectedArrivalDate: Date? = nil) {
        self.notificationID = notificationID
        self.date = date
        self.senderID = senderID
        self.receiverID = receiverID
        self.didSent = didSent
        self.etaExpectedTravelTime = etaExpectedTravelTime
        self.etaDistance = etaDistance
        self.etaExpectedArrivalDate = etaExpectedArrivalDate
    }
}

// MARK: - CodingKeys

extension MapNotification {
    enum CodingKeys: String, CodingKey {
        case notificationID = "notification_id"
        case date
        case senderID = "sender_id"
        case receiverID = "receiver_id"
        case didSent = "did_sent"
        case etaExpectedTravelTime = "eta_expected_travel_time"
        case etaDistance = "eta_distance"
        case etaExpectedArrivalDate = "eta_expected_arrival_date"
    }
}

// MARK: - Codable

extension MapNotification: Codable {

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.notificationID = try container.decode(String.self, forKey: .notificationID)
        self.date = try container.decodeIfPresent(Date.self, forKey: .date)
        self.senderID = try container.decodeIfPresent(String.self, forKey: .senderID)
        self.receiverID = try container.decodeIfPresent(String.self, forKey: .receiverID)
        self.didSent = try container.decodeIfPresent(Bool.self, forKey: .didSent)
        self.etaExpectedTravelTime = try container.decodeIfPresent(Double.self, forKey: .etaExpectedTravelTime)
        self.etaDistance = try container.decodeIfPresent(Double.self, forKey: .etaDistance)
        self.etaExpectedArrivalDate = try container.decodeIfPresent(Date.self, forKey: .etaExpectedArrivalDate)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encode(self.notificationID, forKey: .notificationID)
        try container.encodeIfPresent(self.date, forKey: .date)
        try container.encodeIfPresent(self.senderID, forKey: .senderID)
        try container.encode(self.receiverID, forKey: .receiverID)
        try container.encode(self.didSent, forKey: .didSent)
        try container.encode(self.etaExpectedTravelTime, forKey: .etaExpectedTravelTime)
        try container.encode(self.etaDistance, forKey: .etaDistance)
        try container.encode(self.etaExpectedArrivalDate, forKey: .etaExpectedArrivalDate)
    }
}
