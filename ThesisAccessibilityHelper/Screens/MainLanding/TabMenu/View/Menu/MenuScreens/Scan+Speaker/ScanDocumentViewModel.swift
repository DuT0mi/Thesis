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

protocol ScanDocumentViewModelInput: BaseViewModelInput {
}

final class ScanDocumentViewModel: ObservableObject {
    // MARK: - Types

    typealias Model = TextRecognizer.RecognizedModel

    // MARK: - Properties

    @Published var isSpeakerSpeaks = false
    @Published var isLoading = false

    private(set) lazy var models = [Model]()

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
    private func speak(_ text: String) {
        let scanText = "Szkennelt objektum szöveg tartalma: \(text)"

        speaker.speak(with: scanText)
    }

    private func addObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleNotification), name: .speakerStoppedSpeaking, object: nil)
    }

    @objc private func handleNotification() {
        isSpeakerSpeaks = false
    }

    // MARK: - Intent(s)

    func appendElements(_ elements: [Model], on context: NSManagedObjectContext) {
        isLoading.toggle()

        self.cachedContext = context

        elements.forEach {
            models.append($0)
            CoreDataController().saveData(context: context, $0)
        }

        isLoading.toggle()
    }

    private func mockImages() -> [Image] {
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

        CoreDataController().reset(context: cachedContext)

        models.forEach { CoreDataController().saveTempData(context: cachedContext, $0) }
    }
}
