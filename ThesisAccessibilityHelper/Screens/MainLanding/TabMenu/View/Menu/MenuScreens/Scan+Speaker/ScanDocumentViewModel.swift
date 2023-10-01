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
    // MARK: - Properties

    @Published var isSpeakerSpeaks = false

    private let speaker = SynthesizerManager.shared
    // MARK: - Initialization

    init() {
    }

    // MARK: - Functions

    func speak(_ text: String) {
        isSpeakerSpeaks = true
        let scanText = "Szkennelt objektum szöveg tartalma: \(text)"
        speaker.speak(with: scanText) { [weak self] didFinish in
            guard didFinish else { return }
            self?.isSpeakerSpeaks = false
        }
    }

    func stop() {
        speaker.stop()
        isSpeakerSpeaks.toggle()
    }

    // MARK: - Intent(s)
}
