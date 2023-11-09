//
//  PredictionStatus.swift
//  Kofy
//
//  Created by Diego Gutierrez on 30/10/23.
//

import Foundation
import SwiftUI
import Vision

class PredictionStatus: ObservableObject {
    @Published var modelUrl = URL(fileURLWithPath: "")
    @Published var modelObject = {
        do {
            let config = MLModelConfiguration()
            return try Kofy(configuration: config)
        } catch {
            print(error)
            fatalError("Couldn't create Kofy model")
        }
    }()
    
    @Published var topLabel = ""
    @Published var topConfidence = ""
    
    // Live prediction results
    @Published var livePrediction: LivePredictionResults = [:]
    
    func setLivePrediction(with results: LivePredictionResults, label: String, confidence: String) {
        livePrediction = results
        topLabel = label
        topConfidence = confidence
    }
}
