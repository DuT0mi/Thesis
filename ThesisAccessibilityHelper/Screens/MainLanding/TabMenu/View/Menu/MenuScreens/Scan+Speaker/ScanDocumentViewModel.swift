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
import AVFoundation
import Vision

protocol ScanDocumentViewModelInput: BaseViewModelInput {
}

// swiftlint:disable force_unwrapping

final class ScanDocumentViewModel: ObservableObject {
    // MARK: - Types

    typealias Model = TextRecognizer.RecognizedModel

    enum VolumeButtonType {
        case up
        case down
    }

    enum SystemSoundType: Int {
        case success = 1150
        case error = 1153
        case confirm = 1111
    }

    enum InfoType: String {
        case info = "Amennyiben sikeres az objektum detektálás, nyomd meg a hangerő szabályzó gombot felfele a talált objektum kereséséhez, lefele ha az egész talált képből szeretnéd a keresést."
        case error = "Nincs talált objektum. Kérlek csukd be az aktuális felületet a jobb sarokban lévő gombbal és próbáld újra vagy a lefele gombbal próbálkozz az egész képben való kereséshez."
    }

    // MARK: - Properties

    @Published var isSpeakerSpeaks = false
    @Published var isLoading = false
    @Published var isSearching = false

    var isInteractive: Bool {
        profileVM.interactiveMode
    }
    
    @LazyInjected private var textRecognizer: TextRecognizer
    @LazyInjected private var analyzer: ImageAnalyzer
    @Injected private var speaker: SynthesizerManager
    @Injected private var profileVM: TabProfileLandingViewModel
    @Injected private var hapticManager: HapticManager

    private(set) lazy var models = [Model]()

    private(set) var sortedModels = [SortedModel]()

    private(set) var carouselModel: CarouselModel?

    private var cachedContext: NSManagedObjectContext?

    // MARK: - Initialization

    init() {
        addObservers()
    }

    // MARK: - Functions

    func customSpeak(_ text: String) {
        guard !text.isEmpty else {
            self.playSound(.error)

            return
        }

        isSpeakerSpeaks.toggle()

        speaker.speak(with: text)

        isSpeakerSpeaks.toggle()
    }

    func stop() {
        speaker.stop()
        isSpeakerSpeaks.toggle()
    }

    func showInfo(_ type: InfoType = .info) {
        isSpeakerSpeaks.toggle()
        speaker.speak(with: type.rawValue)
        isSpeakerSpeaks.toggle()
    }

    func didTapVolumeButton(direction type: VolumeButtonType, model: ImageFinderBottomSheetModel, context contestants: FetchedResults<TempData>) {
        guard let cgImg = model.frame else {
            self.playSound(.error)
            self.showInfo(.error)

            return
        }

        if type == .up, model.cameraModel.capturedLabel.isEmpty {
            self.playSound(.error)
            self.showInfo(.error)

            return
        }
   
        textRecognizer(on: UIImage(cgImage: cgImg))

        let carouselModel = CarouselModel(
            id: UUID().uuidString,
            image: Image(cgImg, scale: 1.0, orientation: .upMirrored, label: Text("AccessabilityCGImg")),
            imageData: UIImage(cgImage: cgImg, scale: 1.0, orientation: .upMirrored).pngData() ?? Data(count: .min),
            detectedText: model.cameraModel.capturedLabel
        )

        switch type {
            case .up:
                volumeButtonUpHandler(contestants, for: carouselModel, cropTo: model.cameraModel.capturedObjectBounds)
                debugPrint(String(describing: type))
            case .down:
                volumeButtonDownHandler(contestants, for: carouselModel)
                debugPrint(String(describing: type))
        }
    }

    func playSound(_ type: SystemSoundType) {
        speaker.playSystemSound(SystemSoundID(type.rawValue))
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

    func findSimilarImages(localDataBase coreDataElements: FetchedResults<TempData>, search forItem: CarouselModel) {
        sortedModels.removeAll()
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

    private func volumeButtonUpHandler(_ contestants: FetchedResults<TempData>, for item: CarouselModel, cropTo rect: CGRect) {
        guard let uiImage = cropImage(UIImage(data: item.imageData)!, toRect: rect) else { return }
        var newItem = item
        newItem.image = Image(uiImage: uiImage)
        newItem.imageData = uiImage.pngData() ?? Data(count: .min)

        findSimilarImages(localDataBase: contestants, search: newItem)

        if !sortedModels.isEmpty {
            hapticManager.notificationGenerator(type: .success)
            playSound(.confirm)
        }  else {
            hapticManager.notificationGenerator(type: .error)
            playSound(.error)
        }
    }

    private func volumeButtonDownHandler(_ contestants: FetchedResults<TempData>, for item: CarouselModel) {
        findSimilarImages(localDataBase: contestants, search: item)

        if !sortedModels.isEmpty {
            hapticManager.notificationGenerator(type: .success)
            playSound(.confirm)
        } else {
            hapticManager.notificationGenerator(type: .error)
            playSound(.error)
        }
    }

    private func cropImage(_ inputImage: UIImage, toRect cropRect: CGRect) -> UIImage? {
        let cropZone = CGRect(x: cropRect.origin.x, y: cropRect.origin.y, width: cropRect.size.width, height: cropRect.size.height)

        guard let cutImageRef: CGImage = inputImage.cgImage?.cropping(to: cropZone)
        else {
            return nil
        }

        let croppedImage = UIImage(cgImage: cutImageRef)
        return croppedImage
    }

    private func textRecognizer(on image: UIImage) -> String {
        let detectedText = stringMapper(textRecognizer.findIn(image: image))

        carouselModel = CarouselModel(id: UUID().uuidString, image: Image(uiImage: image), imageData: image.pngData() ?? Data(), detectedText: detectedText)

        return detectedText
    }

    private func stringMapper(_ recArray: [VNRecognizedText]) -> String {
        let array: [String] = recArray.map { $0.string }

        return array.joined(separator: "")
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

        resetCache()
    }

    func resetCache() {
        sortedModels.removeAll()
        carouselModel = nil
    }
}

// swiftlint:enable force_unwrapping
