//
//  SynthesizerManager.swift
//  ThesisAccessibilityHelper
//
//  Created by Dudas Tamas Alex on 2023. 09. 16..
//

import Foundation
import AVFoundation

final class SynthesizerManager: NSObject {
    // MARK: - Types

    struct AVSpeechUtteranceConfiguration {
        var rate: Float = AVSpeechUtteranceDefaultSpeechRate
        var voice = AVSpeechSynthesisVoice(language: "hu_HU" /* AVSpeechSynthesisVoice.currentLanguageCode() */ )!
        var volume: Float = 0.65
        var postUtteranceDelay: TimeInterval = 0.1
    }

    // MARK: - Properties

    class var speakerConfiguration: AVSpeechUtteranceConfiguration {
        return AVSpeechUtteranceConfiguration()
    }

    static let shared = SynthesizerManager()

    private let speaker = AVSpeechSynthesizer()

    // MARK: - Initialization

    private override init() {
        super.init()

        speaker.delegate = self
    }

    // MARK: - Functions

    func speak(with toSay: String) {
        let utterance = AVSpeechUtterance(string: toSay)
        utterance.rate = SynthesizerManager.speakerConfiguration.rate
        utterance.voice = SynthesizerManager.speakerConfiguration.voice
        utterance.volume = SynthesizerManager.speakerConfiguration.volume

        utterance.postUtteranceDelay = SynthesizerManager.speakerConfiguration.postUtteranceDelay

        speaker.speak(utterance)
    }

    func stop() {
        guard speaker.isSpeaking else { return }

        speaker.stopSpeaking(at: .immediate)
    }
}
// MARK: - AVSpeechSynthesizerDelegate

extension SynthesizerManager: AVSpeechSynthesizerDelegate {
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
        NotificationCenter.default.post(name: .speakerStoppedSpeaking, object: nil)
    }
}
