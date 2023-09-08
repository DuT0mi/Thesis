//
//  Localized.swift
//  ThesisAccessibilityHelper
//
//  Created by Dudas Tamas Alex on 2023. 09. 08..
//

import Foundation
import SwiftUI

// swiftlint:disable private_over_fileprivate

fileprivate class LocalizedKeys {
    // MARK: - Properties

    static let helloWorldKey = "hello.world"
}

final class Localized {
    // MARK: - Properties

    static let helloWorld = LocalizedStringKey(LocalizedKeys.helloWorldKey)
}

enum Locales: String {
    case hun
    case en
}
// swiftlint:enable private_over_fileprivate
