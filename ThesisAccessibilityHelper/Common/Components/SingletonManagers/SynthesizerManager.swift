//
//  SynthesizerManager.swift
//  ThesisAccessibilityHelper
//
//  Created by Dudas Tamas Alex on 2023. 09. 16..
//

import Foundation
import AVFoundation

final class SynthesizerManager {
    // MARK: - Properties

    static let shared = SynthesizerManager()

    private let speaker = AVSpeechSynthesizer()

    // MARK: - Initialization

    private init() {  }

    // MARK: - Functions

    func speak(with toSay: String) {
        let utterance = AVSpeechUtterance(string: toSay)
        utterance.rate = AVSpeechUtteranceDefaultSpeechRate
        utterance.voice = AVSpeechSynthesisVoice(language: "hu_HU"/* AVSpeechSynthesisVoice.currentLanguageCode() */) // TODO: Localization
        utterance.volume = 0.35

        speaker.speak(utterance)
    }

    func stop() {
        guard speaker.isSpeaking else { return }

        speaker.stopSpeaking(at: .immediate)
    }
}
