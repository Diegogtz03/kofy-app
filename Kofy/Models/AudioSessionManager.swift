//
//  AudioSessionManager.swift
//  Kofy
//
//  Created by Diego Gutierrez on 18/10/23.
//

import AVFoundation

class AudioSessionManager {
    static let shared = AudioSessionManager()
    
    var recognitionAudioSession: AVAudioSession = AVAudioSession.sharedInstance()
    var playbackAudioSession: AVAudioSession = AVAudioSession.sharedInstance()
    
    func configureRecognitionAudioSession() {
        do {
            try recognitionAudioSession.setCategory(.record, mode: .measurement, options: .mixWithOthers)
            try recognitionAudioSession.setActive(false, options: .notifyOthersOnDeactivation)
            try recognitionAudioSession.setInputGain(0.5)
        } catch {
            print("Error configuring Recognition Audio Session")
        }
    }
    
    func configurePlaybackAudioSession() {
        do {
            try playbackAudioSession.setCategory(.playback, mode: .default, options: .mixWithOthers)
            try playbackAudioSession.setActive(false)
        } catch {
            print("Error configuring Playback Audio Session")
        }
    }
    
    func activateRecognitionSession() {
        do {
            try playbackAudioSession.setActive(false)
            try recognitionAudioSession.setActive(true, options: .notifyOthersOnDeactivation)
            print("ACTIVATED")
        } catch {
            print("Error Activating Recognition Audio Session")
        }
    }
    
    func activatePlaybackSession() {
        do {
            try recognitionAudioSession.setActive(false, options: .notifyOthersOnDeactivation)
            try playbackAudioSession.overrideOutputAudioPort(AVAudioSession.PortOverride.speaker)
            try playbackAudioSession.setActive(true)
        } catch {
            print("Error Activating Recognition Audio Session")
        }
    }
    
    func deactivateAudioSessions() {
        do {
            try recognitionAudioSession.setActive(false)
            try playbackAudioSession.setActive(false)
        } catch {
            print("Error Deactiviating Audio Sessions")
        }
    }
}
