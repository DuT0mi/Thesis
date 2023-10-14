//
//  CarouselModel.swift
//  ThesisAccessibilityHelper
//
//  Created by Dudas Tamas Alex on 2023. 10. 14..
//

import Foundation
import SwiftUI

/// The model that represents an item of the ``ImagesCarousel``
/// - Parameters:
///  - id: The id of the model's intance
///  - image: The hold image
///  - imageData: Image reprsented in binary form.
///  - detectedText: The detected text
struct CarouselModel: Identifiable {
    var id: String

    var image: Image
    var imageData: Data
    var detectedText: String
}
