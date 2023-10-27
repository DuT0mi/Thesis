//
//  AlbumViewModel.swift
//  ThesisAccessibilityHelper
//
//  Created by Dudas Tamas Alex on 2023. 10. 08..
//

import Foundation
import CoreData
import SwiftUI
import Resolver

protocol AlbumViewModelInput: BaseViewModelInput {
}

@MainActor
final class AlbumViewModel: ObservableObject {
    // MARK: - Types

    /// A model that will be displaying in the ``AlbumView``
    /// - Parameters:
    ///  - image: The image of the detected object
    ///  - detectedText: The detected text
    ///  - ID: The ID of the instance
    struct AlbumModel {
        var image: Image
        var detectedText: String
        var modelID: String
    }

    // MARK: - Properties

    @Published private(set) var isLoading = false
    @Published private(set) var model: [AlbumViewModel.AlbumModel]

    @LazyInjected private var speakerInstance: SynthesizerManager

    // MARK: - Initialization

    init() {
        _model = .init(initialValue: [])
    }

    // MARK: - Functions

    func deleteAllItem(on context: NSManagedObjectContext) {
        isLoading = true
        CoreDataController().reset(context: context) { [weak self] in
            self?.isLoading = false
        }
    }

    func mapper(_ fetchedItems: FetchedResults<TempData>) {
        isLoading = true
        let items: [AlbumViewModel.AlbumModel] = fetchedItems.lazy.map { element -> AlbumViewModel.AlbumModel in
            guard let data = element.imageData,
                  let uIimage = UIImage(data: data),
                  let detectedText = element.detectedText,
                  let resultID = element.resultID?.uuidString
            else { return AlbumViewModel.AlbumModel.defaults  }
            return .init(image: Image(uiImage: uIimage), detectedText: detectedText, modelID: resultID)
        }

        model = items.lazy.filter { !$0.modelID.isEmpty && !$0.detectedText.isEmpty }
        isLoading = false
    }

    func speak(_ text: String) {
        guard !text.isEmpty else {
            speakerInstance.speak(with: "Üres")
            speakerInstance.playSystemSound(.error)

            return
        }

        speakerInstance.speak(with: "Talált szöveg: \(text)")
        speakerInstance.playSystemSound(.success)
    }
}

// MARK: - AlbumViewModelInput

extension AlbumViewModel: AlbumViewModelInput {
    func didAppear() {
    }

    func didDisAppear() {
    }
}

// MARK: - AlbumModel

extension AlbumViewModel.AlbumModel {
    static var defaults: AlbumViewModel.AlbumModel = .init(image: Image(.mockImage0), detectedText: "", modelID: "")
}
