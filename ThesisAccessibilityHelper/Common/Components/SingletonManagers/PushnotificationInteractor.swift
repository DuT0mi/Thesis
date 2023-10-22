//
//  PushnotificationInteractor.swift
//  ThesisAccessibilityHelper
//
//  Created by Dudas Tamas Alex on 2023. 10. 22..
//

import Foundation
import UserNotifications
import UIKit

final class PushnotificationInteractor {
    // MARK: - Types

    private struct Consts {
        struct Identifier {
            static let onAppear = "onappear"
        }
    }

    // MARK: - Properties

    // MARK: - Initializaion

    init() {
        requestAuth()
    }

    // MARK: - Functions

    func resetBadge(_ to: Int = .zero) {
        UNUserNotificationCenter.current().setBadgeCount(to) { [weak self] error in
            print("ERROR: \(error)") // TODO: ...
        }
    }

    func onAppearNotification() {
        let content = UNMutableNotificationContent()
        content.title = "Help somebody"
        content.subtitle = "Go to the menu"
        content.sound = .defaultRingtone
        content.badge = 1

        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5.0, repeats: false)

        // TODO: Make it more complex -> Firebase, or location, ...

        let request = UNNotificationRequest(identifier: Consts.Identifier.onAppear, content: content, trigger: trigger )

        UNUserNotificationCenter.current().add(request)
    }

    private func requestAuth() {
        let options: UNAuthorizationOptions = [.alert, .sound, .badge]

        UNUserNotificationCenter.current().requestAuthorization(options: options) { success, error in
            if let error {
                print("ERROR: \(error.localizedDescription)")
            } else {
                print("SUCCESS: \(success)")
            }
        }
    }
}
