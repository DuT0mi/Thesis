//
//  ScanDocumentViewModel.swift
//  ThesisAccessibilityHelper
//
//  Created by Dudas Tamas Alex on 2023. 09. 24..
//

import Combine
import Foundation
import CoreData

final class ScanDocumentViewModel: BaseViewModel {
    // MARK: - Types

    typealias Model = TextRecognizer.RecognizedModel

    // MARK: - Properties

    @Published var isSpeakerSpeaks = false
    @Published var isLoading = false

    private let speaker = SynthesizerManager.shared

    private(set) lazy var models = [Model]()

    // MARK: - Initialization

    override init() {
        super.init()

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

        elements.forEach {
            models.append($0)
            CoreDataController().saveData(context: context, $0)
        }

        isLoading.toggle()
    }
}
