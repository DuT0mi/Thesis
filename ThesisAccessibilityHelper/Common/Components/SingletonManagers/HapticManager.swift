//
//  HapticManager.swift
//  ThesisAccessibilityHelper
//
//  Created by Dudas Tamas Alex on 2023. 10. 13..
//

import Foundation
import UIKit

/// A class that manages the haptics
class HapticManager {
    // MARK: - Properties

    static let shared = HapticManager()

    // MARK: - Initialization

    private init() {  }

    // MARK: - Functions

    func notificationGenerator(type: UINotificationFeedbackGenerator.FeedbackType) {
        let generator = UINotificationFeedbackGenerator()
        generator.prepare()
        generator.notificationOccurred(type)
    }

    func impactGenerator(style: UIImpactFeedbackGenerator.FeedbackStyle) {
        let generator = UIImpactFeedbackGenerator(style: style)
        generator.prepare()
        generator.impactOccurred()
    }

}
