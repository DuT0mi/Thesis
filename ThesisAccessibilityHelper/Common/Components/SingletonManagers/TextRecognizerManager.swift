//
//  TextRecognizerManager.swift
//  ThesisAccessibilityHelper
//
//  Created by Dudas Tamas Alex on 2023. 09. 24..
//

import Vision
import VisionKit

final class TextRecognizer {
    // MARK: - Types

    /// A model that represent a recongized object
    /// - Parameters
    ///   - resultingText: Recognized text via the pages
    ///   - cgImage: The corresponding images to the pages
    ///   - atPage: The current page where text and image have been recongized, if the image is nil then it is also returns a default value: __-1__
    struct RecognizedModel: CustomDebugStringConvertible {
        var debugDescription: String {
            "- resultingText:\n\(self.resultingText),\n - cgImage is nil: \(String(describing: self.cgImage == nil).capitalized),\n - atPage: \(self.atPage)\n"
        }

        // MARK: - Properties

        var resultingText: String
        var cgImage: CGImage?
        var atPage: Int

        static var defaultConfiguration: RecognizedModel = .init(
            resultingText: Consts.Model.textDefault,
            cgImage: nil,
            atPage: Consts.Model.atPageDefaultValue
        )

        // MARK: - Functions

        mutating func setDefault() {
            self = RecognizedModel.defaultConfiguration
        }
    }

    private struct Consts {
        struct Model {
            static let atPageDefaultValue = -1
            static let textDefault = ""
        }
    }
    // MARK: - Properties

    static let shared = TextRecognizer()

    var scan: VNDocumentCameraScan? {
        didSet {
            guard let scan else { return }
            setupVision()
        }
    }
    private var requests = [VNRequest]()
    private let textRecognitionQueue = DispatchQueue(label: "TextRecognitionQueue", qos: .userInitiated, attributes: [], autoreleaseFrequency: .workItem )
    private var resultingText: String = ""

    private var models: [RecognizedModel] = []

    private var cachedItem = RecognizedModel.defaultConfiguration

    // MARK: - Initialization

    private init() {  }

    // MARK: - Functions

    // swiftlint:disable force_unwrapping
    func request(willStart: (() -> Void)?, didFinish: ((_ recongnizedModels: [RecognizedModel]) -> Void)?) {
        willStart?()

        self.textRecognitionQueue.async { [weak self] in
            guard let self else { return }

            self.models.removeAll()

            for pageIndex in 0 ..< self.scan!.pageCount {
                self.resultingText = ""
                self.cachedItem.setDefault()
                let image = self.scan!.imageOfPage(at: pageIndex)
                if let cgImage = image.cgImage {
                    self.cachedItem.atPage = pageIndex
                    self.cachedItem.cgImage = cgImage

                    let requestHandler = VNImageRequestHandler(cgImage: cgImage, options: [:])
                    do {
                        try requestHandler.perform(self.requests)
                    } catch {
                        print(error)
                    }
                }

                self.resultingText += "\n\n"
                self.cachedItem.resultingText = self.resultingText
                models.append(cachedItem)
            }
            DispatchQueue.main.async(execute: {
                didFinish?(self.models)
            })
        }
    }

    private func setupVision() {
        let textRecognitionRequest = VNRecognizeTextRequest { (request, error) in // TODO: Publishing error
            guard let observations = request.results as? [VNRecognizedTextObservation] else {
                print("Not found proper observations at: \(#file), \(#function), \(#column)")
                return
            }

            let maximumCandidates = 1
            for observation in observations {
                guard let candidate = observation.topCandidates(maximumCandidates).first else { continue }
                self.resultingText += candidate.string + "\n"
            }
        }
        textRecognitionRequest.recognitionLevel = .accurate
        self.requests = [textRecognitionRequest]
    }
}
// swiftlint:enable force_unwrapping
