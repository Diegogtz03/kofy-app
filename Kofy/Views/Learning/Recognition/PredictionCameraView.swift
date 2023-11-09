//
//  PredictionCameraView.swift
//  Kofy
//
//  Created by Diego Gutierrez on 30/10/23.
//

import SwiftUI

struct PredictionCameraView : View {
    @Binding var showingView: Bool
    @Binding var cardsShown: Bool
    @Binding var selectedCardId: Int
    @EnvironmentObject var predictionStatus: PredictionStatus
    @StateObject var classifierViewModel = ClassifierViewModel()
    
    var body: some View {
        let predictionLabel = predictionStatus.topLabel
        
        GeometryReader { geo in
            ZStack(alignment: .bottom) {
                LiveCameraRepresentable() {
                    predictionStatus.setLivePrediction(with: $0, label: $1, confidence: $2)
                }
                .frame(width: geo.size.width, height: geo.size.height)
                
                Button {
                    showingView.toggle()
                } label: {
                    VStack {
                        Image(systemName: "chevron.down")
                            .resizable()
                            .scaledToFit()
                            .bold()
                            .foregroundStyle(.white)
                            .frame(width: 40)
                            .padding(30)
                        Spacer()
                    }
                    .frame(width: geo.size.width, alignment: .leading)
                    .safeAreaPadding(.top)
                    .padding([.top, .leading], 15)
                }
                
                PredictionLabel(labelData: classifierViewModel.getPredictionData(label: predictionLabel), showingView: $showingView, showingCards: $cardsShown, selectedCardId: $selectedCardId)
                
            }
            .onAppear(perform: classifierViewModel.loadJSON)
            .frame(width: geo.size.width, height: geo.size.height)
        }
    }
}

#Preview {
    PredictionCameraView(showingView: .constant(true), cardsShown: .constant(true), selectedCardId: .constant(0))
}
