//
//  NotificationName+Names.swift
//  ThesisAccessibilityHelper
//
//  Created by Dudas Tamas Alex on 2023. 09. 30..
//

import Foundation

extension Notification.Name {
    static let speakerStartedSpeaking = Notification.Name("speakerStarterdSpeaking")
    static let speakerStoppedSpeaking = Notification.Name("speakerStarterdSpeaking")

}

@objc extension NSNotification {
    static let speakerStartedSpeaking = Notification.Name.speakerStartedSpeaking
    static let speakerStoppedSpeaking = Notification.Name.speakerStoppedSpeaking
}
