//
//  TextRecognizerManager.swift
//  ThesisAccessibilityHelper
//
//  Created by Dudas Tamas Alex on 2023. 09. 24..
//

import Vision
import VisionKit

final class TextRecognizer {
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

    // MARK: - Initialization

    private init() {  }

    // MARK: - Functions
    
    func request(willStart: (() -> Void)?, didFinish: ((String) -> Void)?) {
        willStart?()

        self.textRecognitionQueue.async {
            self.resultingText = ""
            for pageIndex in 0 ..< self.scan!.pageCount {
                let image = self.scan!.imageOfPage(at: pageIndex)
                if let cgImage = image.cgImage {
                    let requestHandler = VNImageRequestHandler(cgImage: cgImage, options: [:])
                    do {
                        try requestHandler.perform(self.requests)
                    } catch {
                        print(error)
                    }
                }
                self.resultingText += "\n\n"
            }
            DispatchQueue.main.async(execute: {
                didFinish?(self.resultingText)
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
