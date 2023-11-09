//
//  LearnCardsPopup.swift
//  Kofy
//
//  Created by Diego Gutierrez on 25/10/23.
//

import SwiftUI
import BigUIPaging
import YouTubePlayerKit

struct LearnCardsPopup: View {
    @Binding var popupIsShown: Bool
    @StateObject var learnVM = LearnCardsViewModel()
    @State private var selection: Int = 1
    @StateObject var youTubePlayer: YouTubePlayer = "https://www.youtube.com/watch?v=oZsH-tuHwQw"
    
    func closeCards() {
        withAnimation {
            popupIsShown.toggle()
        } completion: {
            selection = 1
        }
    }
    
    var body: some View {
        PageView(selection: $selection) {
            ForEach(learnVM.cards) { card in
                ZStack {
                    Color(.white)
                    VStack {
                        ZStack {
                            Color("LearnCardColor")
                            HStack {
                                Image(card.lessonIconLink)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 70)
                                    .padding()
                                Text(card.lessonName)
                                    .font(.system(size: 50, weight: .bold))
                                Button {
                                    closeCards()
                                } label: {
                                    Image(systemName: "x.circle")
                                        .resizable()
                                        .scaledToFit()
                                        .foregroundStyle(.gray)
                                        .frame(width: 25, height: 25)
                                        .padding()
                                }
                            }
                        }
                        .frame(maxHeight: 130)
                        
                        Text("\(card.id)")
                            .font(.system(.largeTitle))
                            .foregroundStyle(.gray)
                            .bold()
                            .padding([.bottom])
                        
                        Text("\(card.content)")
                            .font(.system(.title))
                            .foregroundStyle(.gray)
                            .bold()
                            .padding([.leading, .trailing])
                        
                        if (!card.isVideo) {
                            Image(card.imageLink!)
                                .resizable()
                                .scaledToFit()
                                .padding([.leading, .trailing], 40)
                        } else {
                            YouTubePlayerView(youTubePlayer)
                                .padding()
                                .clipShape(RoundedRectangle(cornerRadius: 18))
                        }
                        
                        Spacer()
                        
                        if (card.id == 1) {
                            HStack {
                                Image(systemName: "arrow.turn.up.left")
                                    .foregroundStyle(.gray)
                                Text("Desliza")
                                    .font(.system(.title3))
                                    .foregroundStyle(.gray)
                                Image(systemName: "arrow.turn.up.right")
                                    .foregroundStyle(.gray)
                            }
                            .bold()
                            .padding()
                        } else if (card.id == learnVM.cards.count) {
                            Button {
                                closeCards()
                            } label: {
                                ZStack {
                                    Color(.blue)
                                    Text("Completar")
                                        .foregroundStyle(.white)
                                        .font(.system(.title))
                                        .bold()
                                }
                                .frame(height: 50)
                                .clipShape(RoundedRectangle(cornerRadius: 25.0))
                                .padding(20)
                            }
                        }
                    }
                }
            }
        }
        .pageViewStyle(.cardDeck)
    }
}

#Preview {
    return LearnCardsPopup(popupIsShown: .constant(true))
}
