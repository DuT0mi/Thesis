//
//  ScanDocumentViewModel.swift
//  ThesisAccessibilityHelper
//
//  Created by Dudas Tamas Alex on 2023. 09. 24..
//

import Combine
import Foundation

@MainActor
final class ScanDocumentViewModel: ObservableObject {
    // MARK: - Types

    typealias Model = TextRecognizer.RecognizedModel

    // MARK: - Properties

    @Published var isSpeakerSpeaks = false

    private let speaker = SynthesizerManager.shared

    private lazy var models = [Model]()

    // MARK: - Initialization

    init() {
        addObservers()
    }

    // MARK: - Functions

    func stop() {
        speaker.stop()
        isSpeakerSpeaks.toggle()
    }

    func start() {
        isSpeakerSpeaks = true

        self.speak(models.map { $0.resultingText}.joined())
    }

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

    func appendElement(_ element: Model) {
        models.append(element)
    }
}
