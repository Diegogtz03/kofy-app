//
//  TextToSpeech.swift
//  Kofy
//
//  Created by Diego Gutierrez on 12/10/23.
//

import SwiftUI
import Foundation
import AVFoundation

protocol SpeechSynthesizerProviding {
    func speakText(_ text: String, completion: @escaping () -> Void)
}

final class SpeechSynthesizer: NSObject, SpeechSynthesizerProviding, AVSpeechSynthesizerDelegate {
    let synthesizer = AVSpeechSynthesizer()
    var completionBlock: (() -> Void)?
    
    func speakText(_ text: String, completion: @escaping () -> Void) {
        let utterance = AVSpeechUtterance(string: text)
        utterance.voice = AVSpeechSynthesisVoice(language: "es-MX")
        self.completionBlock = completion
        synthesizer.delegate = self
        synthesizer.speak(utterance)
    }

    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
        DispatchQueue.main.async {
            self.completionBlock?()
            self.completionBlock = nil
        }
    }
}

@MainActor
final class ContentViewModel: ObservableObject {
    @Published var text: String = ""
    
    let speechSynthesizer: SpeechSynthesizerProviding
    
    init(speechSynthesizer: SpeechSynthesizerProviding) {
        self.speechSynthesizer = speechSynthesizer
    }
    
    func textToSpeech(completion: @escaping () -> Void) {
        speechSynthesizer.speakText(self.text) {
            completion()
        }
    }
}
