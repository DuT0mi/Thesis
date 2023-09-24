//
//  ScanDocumentViewModel.swift
//  ThesisAccessibilityHelper
//
//  Created by Dudas Tamas Alex on 2023. 09. 24..
//

import Combine

@MainActor
final class ScanDocumentViewModel: ObservableObject {
    // MARK: - Properties

    @Published var isSpeakerSpeaks = false

    private let speaker = SynthesizerManager.shared
    // MARK: - Initialization

    init() {
    }

    // MARK: - Functions

    func speak(_ text: String) {
        isSpeakerSpeaks.toggle()
        let scanText = "Szkennelt objektum szöveg tartalma: \(text)"
        speaker.speak(with: scanText) { [weak self] didFinish in
            guard didFinish else { return }
            self?.isSpeakerSpeaks.toggle()
        }
    }

    func stop() {
        speaker.stop()
    }
}
