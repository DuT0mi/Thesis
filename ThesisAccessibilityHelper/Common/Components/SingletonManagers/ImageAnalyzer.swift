//
//  ImageAnalyzer.swift
//  ThesisAccessibilityHelper
//
//  Created by Dudas Tamas Alex on 2023. 10. 11..
//

import Foundation
import Vision
import SwiftUI

/// A class that can find the featureprint observation (alias distance) between images, also capable for sort the result
final class ImageAnalyzer {
    // MARK: - Properties

    static let shared = ImageAnalyzer()

    // MARK: - Initialization

    private init() {
    }

    // MARK: - Functions

    func processImages(
        original: CarouselModel,
        contestants: [CarouselModel],
        completion: @escaping (Result<[(model: CarouselModel, index: Int, featureprintDistance: Float)], URLError>) -> Void) {
        var ranks = [(model: CarouselModel, index: Int, featureprintDistance: Float)]()

        guard let originalFPO = featureprintObservationForImage(data: original.imageData) else {
            print("TODO | ERROR | AT: \(#function)")

            return
        }

        for indexAt in contestants.indices {
            let contestantData = contestants[indexAt].imageData
            if let indexAtContestantDataFPO = featureprintObservationForImage(data: contestantData) {
                do {
                    var distance = Float(0)
                    try indexAtContestantDataFPO.computeDistance(&distance, to: originalFPO)
                    ranks.append((model: contestants[indexAt], index: indexAt, featureprintDistance: distance))
                } catch {
                    print("Error computing distance between featureprints.")
                }
            } else {
                print("indexAtContestantDataFPO | IDX:\(indexAt) | AT: \(#file) ROW: \(#line)")
            }
        }

        ranks.sort { lhs, rhs in
            lhs.featureprintDistance < rhs.featureprintDistance
        }

        switch ranks.count {
            case 0:
                completion(.failure(URLError.init(.badURL)))
            default:
                completion(.success(ranks))
        }
    }

    private func featureprintObservationForImage(data: Data) -> VNFeaturePrintObservation? {
        let requestHandler = VNImageRequestHandler(data: data, options: [:])

        let request = VNGenerateImageFeaturePrintRequest()
        do {
            try requestHandler.perform([request])
            return request.results?.first as? VNFeaturePrintObservation
        } catch {
            print("Vision error: \(error)")
            return nil
        }
    }
}
