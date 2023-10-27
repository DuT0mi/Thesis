//
//  DemoItem.swift
//  ThesisAccessibilityHelper
//
//  Created by Dudas Tamas Alex on 2023. 10. 27..
//

import Foundation
import SwiftUI

/// A Model that represent a DemoItem in the DemoData
/// - Parameters:
///  - id: The id of the Item
///  - title: The title of the Item
///  - description: The description of the Item
///  - image: The image of the Item
struct DemoItem: Hashable, Codable, Identifiable {
    var id: Int
    var title: String
    var description: String

    var image: Image {
        Image(imageName)
    }

    private var imageName: String
}
