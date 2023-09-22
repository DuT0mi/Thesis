//
//  TextRecognizerManager.swift
//  ThesisAccessibilityHelper
//
//  Created by Dudas Tamas Alex on 2023. 09. 22..
//

import UIKit
import MLKitVision
import MLKitTextRecognition

final class TextRecognizerManager {
    // MARK: - Properties

    static let shared = TextRecognizerManager()

    private lazy var textRecognizer: TextRecognizer = {
        let recognizer = TextRecognizer.textRecognizer(options: TextRecognizerOptions())

        return recognizer
    }()

    // MARK: - Initialization

    private init() {  }

    // MARK: - Functions

    func recognize(_ uiImage: UIImage, completion: @escaping (Result<String, Error>) -> Void ) {
        let image = VisionImage(image: uiImage)
        image.orientation = .upMirrored

        textRecognizer.process(image) { result, error in
            guard error == nil , let result else {
                completion(.failure(error!))

                return
            }
            completion(.success(result.text))

//            let resultText = result.text
//            for block in result.blocks {
//                let blockText = block.text
//                let blockLanguages = block.recognizedLanguages
//                print("LINE BLOCK LANGUAGES | \(blockLanguages)")
//                let blockCornerPoints = block.cornerPoints
//                let blockFrame = block.frame
//                for line in block.lines {
//                    let lineText = line.text
//                    print("LINE TEXT | \(lineText)")
//                    let lineLanguages = line.recognizedLanguages
//                    print("LINE LANGUAGES | \(lineLanguages)")
//                    let lineCornerPoints = line.cornerPoints
//                    let lineFrame = line.frame
//                    for element in line.elements {
//                        let elementText = element.text
//                        print("ELEMENT | \(elementText)")
//                        let elementCornerPoints = element.cornerPoints
//                        let elementFrame = element.frame
//                    }
//                }
//            }
        }

    }
}
