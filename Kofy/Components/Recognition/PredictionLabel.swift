//
//  PredictionLabel.swift
//  Kofy
//
//  Created by Diego Gutierrez on 30/10/23.
//

import SwiftUI

struct PredictionLabel: View {
    private(set) var labelData: Classification
    @Binding var showingView: Bool
    @Binding var showingCards: Bool
    @Binding var selectedCardId: Int
    @Binding var selectedTitle: String
    @Binding var selectedIcon: String
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                Spacer()
                
                Button {
                    selectedCardId = labelData.id
                    selectedTitle = labelData.label
                    selectedIcon = labelData.image
                    showingView.toggle()
                    withAnimation {
                        showingCards.toggle()
                    }
                } label : {
                    HStack(spacing: 20) {
                        Image(labelData.image)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 70)
                        Text(labelData.label)
                            .scaledToFit()
                            .font(Font.system(.largeTitle, weight: .bold))
                            .foregroundColor(.black)
                        Spacer()
                        Image(systemName: "chevron.right")
                            .resizable()
                            .scaledToFit()
                            .bold()
                            .foregroundStyle(.black)
                            .frame(width: 15)
                            .padding([.trailing], 8)
                    }
                    .frame(width: geometry.size.width - 40)
                    .padding(8)
                    .background(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                }
                .padding([.bottom])
                .frame(width: geometry.size.width)
            }
        }
    }
}

#Preview {
    PredictionLabel(labelData: Classification(), showingView: .constant(true), showingCards: .constant(true), selectedCardId: .constant(0), selectedTitle: .constant(""), selectedIcon: .constant(""))
}
