//
//  ScanDocumentViewModel.swift
//  ThesisAccessibilityHelper
//
//  Created by Dudas Tamas Alex on 2023. 09. 24..
//

import Combine
import Foundation
import CoreData
import SwiftUI
import Resolver

protocol ScanDocumentViewModelInput: BaseViewModelInput {
}

// swiftlint:disable force_unwrapping

final class ScanDocumentViewModel: ObservableObject {
    // MARK: - Types

    typealias Model = TextRecognizer.RecognizedModel

    // MARK: - Properties

    @Published var isSpeakerSpeaks = false
    @Published var isLoading = false
    @Published var isSearching = false

    @LazyInjected private var analyzer: ImageAnalyzer
    @Injected private var speaker: SynthesizerManager

    private(set) lazy var models = [Model]()

    private(set) var sortedModels = [SortedModel]()

    private var cachedContext: NSManagedObjectContext?

    // MARK: - Initialization

    init() {
        addObservers()
    }

    // MARK: - Functions

    func stop() {
        speaker.stop()
        isSpeakerSpeaks.toggle()
    }

    @MainActor
    func start() {
        isSpeakerSpeaks = true

        self.speak(models.map { $0.resultingText}.joined())
    }

    @MainActor
    func modelMapper(from localDataElements: FetchedResults<LocalData>) -> [CarouselModel] {
        localDataElements
            .filter { $0.imageData != nil && $0.imageText != nil && $0.imageId != nil }
            .map { CarouselModel(
                id: $0.imageId!.uuidString,
                image: Image(uiImage: UIImage(data: $0.imageData!)!),
                imageData: $0.imageData!,
                detectedText: $0.imageText!)
            }
    }

    func findSimilarImages(
        localDataBase coreDataElements: FetchedResults<TempData>, search forItem: CarouselModel) {
        isSearching.toggle()
        analyzer.processImages(original: forItem, contestants: modelMapper(from: coreDataElements)) { [weak self] result in
            defer { self?.isSearching.toggle() }
            switch result {
                case .success(let model):
                    self?.sortedModels = model.map { SortedModel(carouselModel: $0.model, index: $0.index, featureprintDistance: $0.featureprintDistance) }
                case .failure(let error):
                    print("ERROR: \(error)")
            }
        }
    }

    func resetLocalDB(context: NSManagedObjectContext) {
        isLoading = true
        CoreDataController().reset(context: context)
        isLoading = false
    }

    @MainActor
    private func speak(_ text: String) {
        guard !text.isEmpty else { return }

        let scanText = "Szkennelt objektum szöveg tartalma: \(text)"

        speaker.speak(with: scanText)
    }

    private func addObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleNotification), name: .speakerStoppedSpeaking, object: nil)
    }

    @objc private func handleNotification() {
        isSpeakerSpeaks = false
    }

    private func modelMapper(from localDataElements: FetchedResults<TempData>) -> [CarouselModel] {
        localDataElements
            .filter { $0.imageData != nil && $0.detectedText != nil && $0.resultID != nil }
            .map { CarouselModel(
                id: $0.resultID!.uuidString,
                image: Image(uiImage: UIImage(data: $0.imageData!)!),
                imageData: $0.imageData!,
                detectedText: $0.detectedText!)
            }
    }

    // MARK: - Intent(s)

    func appendElements(_ elements: [Model], on context: NSManagedObjectContext) {
        isLoading.toggle()

        self.cachedContext = context

        elements.forEach {
            guard !$0.resultingText.isEmpty && $0.cgImage != nil else { return }; #warning("Show error")
            models.append($0)
            CoreDataController().saveData(context: context, $0)
        }

        isLoading.toggle()
    }

    func mockImages() -> [Image] {
        [
            Image(.mockImage0),
            Image(.mockImage1),
            Image(.mockImage2),
            Image(.mockImage3),
            Image(.mockImage4)
        ]
    }
}

// MARK: - ScanDocumentViewModelInput

extension ScanDocumentViewModel: ScanDocumentViewModelInput {
    func didAppear() {
    }

    func didDisAppear() {
        guard let cachedContext else { return }

        resetLocalDB(context: cachedContext)

        models.forEach { CoreDataController().saveTempData(context: cachedContext, $0) }
    }
}

// swiftlint:enable force_unwrapping
