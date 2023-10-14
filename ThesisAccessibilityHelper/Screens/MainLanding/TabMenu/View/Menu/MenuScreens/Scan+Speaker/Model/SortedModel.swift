//
//  SortedModel.swift
//  ThesisAccessibilityHelper
//
//  Created by Dudas Tamas Alex on 2023. 10. 14..
//

import Foundation

/// A Model that represents the found protestants
/// - Parameters:
///  - id: The id of the model's instance
///  - carouselModel: For more information see ``CarouselModel``
///  - index: The current index of the model's instance
///  - featureprintDistance: The distance from the reference image
struct SortedModel: Identifiable, Hashable {
    var id = UUID()

    var carouselModel: CarouselModel
    var index: Int
    var featureprintDistance: Float

    static func == (lhs: SortedModel, rhs: SortedModel) -> Bool {
        lhs.featureprintDistance == rhs.featureprintDistance &&
        lhs.index == rhs.index &&
        lhs.carouselModel.id == rhs.carouselModel.id &&
        lhs.carouselModel.image == rhs.carouselModel.image &&
        lhs.carouselModel.imageData == rhs.carouselModel.imageData &&
        lhs.carouselModel.detectedText == rhs.carouselModel.detectedText

    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(index)
        hasher.combine(featureprintDistance)
    }
}
