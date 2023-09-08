//
//  AppConstants.swift
//  ThesisAccessibilityHelper
//
//  Created by Dudas Tamas Alex on 2023. 09. 08..
//

import UIKit

final class AppConstants {
    struct ScreenDimensions {
        #if os(iOS) || os(tvOS)
            static let width: CGFloat = UIScreen.main.bounds.width
            static let height: CGFloat = UIScreen.main.bounds.height
        #elseif os(macOS)
            static var width: CGFloat = NSScreen.main?.visibleFrame.size.width ?? 0
            static var heigth: CGFloat = NSScreen.main?.visibleFrame.size.height ?? 0
        #endif
    }
}
