//
//  SynthesizerManager.swift
//  ThesisAccessibilityHelper
//
//  Created by Dudas Tamas Alex on 2023. 09. 16..
//

import Foundation
import AVFoundation

final class SynthesizerManager: NSObject {
    // MARK: - Properties

    static let shared = SynthesizerManager()

    private let speaker = AVSpeechSynthesizer()

    private var completion: ((Bool) -> Void)?

    // MARK: - Initialization

    private override init() {
        super.init()

        speaker.delegate = self
    }

    // MARK: - Functions

    func speak(with toSay: String, completion: ((Bool) -> Void)?) {
        let utterance = AVSpeechUtterance(string: toSay)
        utterance.rate = AVSpeechUtteranceDefaultSpeechRate
        utterance.voice = AVSpeechSynthesisVoice(language: "hu_HU" /* AVSpeechSynthesisVoice.currentLanguageCode() */ )
        utterance.volume = 0.65

        utterance.postUtteranceDelay = 0.1

        self.completion = completion

        speaker.speak(utterance)
    }

    func stop() {
        guard speaker.isSpeaking else { return }

        speaker.stopSpeaking(at: .immediate)
    }
}

extension SynthesizerManager: AVSpeechSynthesizerDelegate {
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
        completion?(true)
        completion = nil
    }
}
