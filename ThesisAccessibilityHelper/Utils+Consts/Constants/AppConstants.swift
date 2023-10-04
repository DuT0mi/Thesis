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
            static let bounds: CGRect = UIScreen.main.bounds
        #elseif os(macOS)
            static var width: CGFloat = NSScreen.main?.visibleFrame.size.width ?? 0
            static var heigth: CGFloat = NSScreen.main?.visibleFrame.size.height ?? 0
        #endif
    }

    struct Screens {
        struct Common {
            struct Appearance {
                struct Color {
                    static let opacityNewValueMax: CGFloat = 0.9999
                    static let opacityNewValueMin: CGFloat = 0.0001
                    static let opacityDefaultLow: CGFloat = 0.35
                    static let opacityDefaultMedium: CGFloat = 0.5
                }
            }
        }
    }

    struct Mock {
        struct Image {
            static let link = "https://picsum.photos/200/300"
        }
    }
}

extension AppConstants {
    typealias AppColor = AppConstants.Screens.Common.Appearance.Color
    typealias AppDimension = AppConstants.ScreenDimensions
}
