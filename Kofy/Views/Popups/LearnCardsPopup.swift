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
    @EnvironmentObject var cardCollectionInfo: LearningViewModel
    @State var selection: Int = 1
    @Binding var collectionName: String
    @Binding var collectionIconLink: String
    @Binding var cardType: Int
    
    let autoPlayConfig = YouTubePlayer.Configuration(
        fullscreenMode: .system,
        autoPlay: true,
        showControls: false,
        loopEnabled: true
    )
    
    let normalConfig = YouTubePlayer.Configuration(
        fullscreenMode: .system,
        autoPlay: false,
        showControls: true,
        loopEnabled: true
    )
    
    func closeCards() {
        withAnimation {
            popupIsShown.toggle()
        } completion: {
            selection = 1
        }
    }
    
    var body: some View {
        if (!cardCollectionInfo.cardCollectionCards.isEmpty) {
            PageView(selection: $selection) {
                ForEach(cardCollectionInfo.cardCollectionCards, id: \.self.index) { card in
                    ZStack {
                        Color(.white)
                        VStack {
                            ZStack {
                                Color("LearnCardColor")
                                HStack {
                                    if collectionIconLink.hasPrefix("http") {
                                        AsyncImage(url: URL(string: collectionIconLink)) { phase in
                                            switch phase {
                                            case .empty:
                                                ProgressView()
                                            case .success(let image):
                                                image.resizable()
                                                    .scaledToFit()
                                                    .frame(width: 70)
                                                    .padding()
                                            case .failure:
                                                Image(systemName: "photo")
                                            @unknown default:
                                                EmptyView()
                                            }
                                        }
                                    } else {
                                        Image(collectionIconLink)
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 70)
                                            .padding()
                                    }
                                    
                                    Text(collectionName)
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
                            
                            if (card.index != 1 && card.index != 2) {
                                Text("\(card.index - 2)")
                                    .font(.system(.title))
                                    .foregroundStyle(.gray)
                                    .bold()
                                    .padding([.bottom], 5)
                            }
                            
                            Text("\(card.content)")
                                .font(.system(.title))
                                .foregroundStyle(.gray)
                                .bold()
                                .padding([.leading, .trailing])
                            
                            if (!card.isVideo) {
                                AsyncImage(url: URL(string: card.imageLink!)) { phase in
                                    switch phase {
                                    case .empty:
                                        ProgressView()
                                    case .success(let image):
                                        image.resizable()
                                            .scaledToFit()
                                    case .failure:
                                        Image(systemName: "photo")
                                    @unknown default:
                                        EmptyView()
                                    }
                                }
                                .clipShape(RoundedRectangle(cornerRadius: 20))
                                .padding([.leading, .trailing], 40)
                            } else {
                                YouTubePlayerView(
                                    .init(
                                        source: .url(card.videoLink!),
                                        configuration: card.index == 1 ? autoPlayConfig : normalConfig
                                    )
                                )
                                .padding()
                                .clipShape(RoundedRectangle(cornerRadius: 18))
                            }
                            
                            Spacer()
                            
                            if (card.index == 1) {
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
                            } else if (card.id == cardCollectionInfo.cardCollectionCards.count) {
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
}

#Preview {
    return LearnCardsPopup(popupIsShown: .constant(true), collectionName: .constant(""), collectionIconLink: .constant(""), cardType: .constant(1))
}
