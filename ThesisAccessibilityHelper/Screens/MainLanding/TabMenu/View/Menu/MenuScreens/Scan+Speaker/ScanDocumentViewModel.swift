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

//swiftlint:disable force_unwrapping

final class ScanDocumentViewModel: ObservableObject {
    // MARK: - Types

    typealias Model = TextRecognizer.RecognizedModel

    struct CaoruselModel: Identifiable {
        var image: Image
        var imageData: Data
        var detectedText: String
        var id: String
    }

    struct SortedModel: Identifiable, Hashable {
        var id = UUID()
        
        var carouselModel: CaoruselModel
        var index: Int
        var featureprintDistance: Float

        static func == (lhs: ScanDocumentViewModel.SortedModel, rhs: ScanDocumentViewModel.SortedModel) -> Bool {
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

    // MARK: - Properties

    @Published var isSpeakerSpeaks = false
    @Published var isLoading = false
    @Published var isSearching = false

    @LazyInjected private var analyzer: ImageAnalyzer

    private(set) lazy var models = [Model]()

    private(set) var sortedModels = [SortedModel]()

    private let speaker = SynthesizerManager.shared

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
    func modelMapper(from localDataElements: FetchedResults<LocalData>) -> [ScanDocumentViewModel.CaoruselModel] {
        localDataElements
            .filter { $0.imageData != nil && $0.imageText != nil && $0.imageId != nil }
            .map { ScanDocumentViewModel.CaoruselModel(
                image: Image(uiImage: UIImage(data: $0.imageData!)!),
                imageData: $0.imageData!,
                detectedText: $0.imageText!,
                id: $0.imageId!.uuidString)
            }
    }

    func findSimilarImages(
        localDataBase coreDataElements: FetchedResults<TempData>, search forItem: CaoruselModel) {
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

    private func modelMapper(from localDataElements: FetchedResults<TempData>) -> [ScanDocumentViewModel.CaoruselModel] {
        localDataElements
            .filter { $0.imageData != nil && $0.detectedText != nil && $0.resultID != nil }
            .map { ScanDocumentViewModel.CaoruselModel(
                image: Image(uiImage: UIImage(data: $0.imageData!)!),
                imageData: $0.imageData!,
                detectedText: $0.detectedText!,
                id: $0.resultID!.uuidString)
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

         resetLocalDB(context: cachedContext) // Saving just the `TempData`

        models.forEach { CoreDataController().saveTempData(context: cachedContext, $0) }
    }
}

// swiftlint:enable force_unwrapping
