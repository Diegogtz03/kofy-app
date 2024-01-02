//
//  LearnView.swift
//  Kofy
//
//  Created by Diego Gutierrez on 14/10/23.
//

import SwiftUI

struct LearnListView: View {
    @EnvironmentObject var authInfo: VerificationViewModel
    @StateObject var cardCollections: LearningViewModel = LearningViewModel(userService: UserService())
    @Binding var cardsShown: Bool
    @Binding var selectedCardId: Int
    let columns = [GridItem(.flexible()), GridItem(.flexible())]
    
    @State var filtersShown = false
    @State var searchText = ""
    @State var cardType = 0
    
    @Binding var cardCollectionName: String
    @Binding var cardCollectionIconLink: String
    
    var filteredCardCollections:[CardCollectionInfo] {
        cardCollections.cardCollections.filter { content in
            (!filtersShown || content.name.lowercased().hasPrefix(searchText.lowercased()))
        }
    }
    
    func closeCards() {
        withAnimation {
            cardsShown.toggle()
        }
    }
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Color("BackgroundColor")
                    .ignoresSafeArea()
                
                VStack {
                    VStack(spacing: 0) {
                        Color(Color(red: 0.85, green: 0.85, blue: 0.85))
                            .ignoresSafeArea()
                            .frame(maxHeight: 0)
                        VStack {
                            HStack {
                                Text("Lecciones")
                                    .font(Font.system(size: 35, weight: .bold))
                                    .foregroundStyle(Color(red: 0.278, green: 0.278, blue: 0.278))
                                    .padding([.leading], 30)
                                Spacer()
                                VStack {
                                    Button {
                                        withAnimation(Animation.easeInOut(duration: 0.3)) {
                                            filtersShown.toggle()
                                            searchText = ""
                                        }
                                    } label: {
                                        Image(systemName: "line.3.horizontal.decrease.circle.fill")
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 30)
                                            .padding([.trailing], 10)
                                            .foregroundStyle(.gray)
                                    }
                                }
                                .frame(width: 70, height: 53)
                            }
                            if (filtersShown) {
                                HStack(alignment: .center) {
                                    TextField("Busqueda", text: $searchText, prompt: Text("Busqueda").foregroundStyle(.gray))
                                        .padding(7)
                                        .background(.white)
                                        .foregroundStyle(.black)
                                        .clipShape(RoundedRectangle(cornerRadius: 8))
                                        .frame(width: .infinity)
                                    
                                    Spacer()
                                    
                                    Picker("Tipo de contenido", selection: $cardType, content: {
                                        Text("Todo").tag(0)
                                        Text("Videos").tag(1)
                                        Text("Texto").tag(2)
                                    })
                                    .tint(.gray)
                                    .tint(.black)
                                    .background(.white)
                                    .clipShape(RoundedRectangle(cornerRadius: 8))
                                }
                                .frame(height: 30)
                                .padding([.leading, .trailing])
                                .padding([.bottom], 5)
                            }
                        }
                        .padding(8)
                        .background(Color(red: 0.85, green: 0.85, blue: 0.85))
                        .clipShape(
                            .rect(
                                bottomLeadingRadius: 20,
                                bottomTrailingRadius: 20
                            )
                        )
                    }
                    
                    Spacer()
                        
                    ScrollView {
                        LazyVGrid(columns: columns, alignment: .center, spacing: 15) {
                            ForEach(filteredCardCollections) {card in
                                LearnCard(cardCollectionInfo: card)
                                    .onTapGesture {
                                        cardCollectionName = card.name
                                        cardCollectionIconLink = card.icon
                                        selectedCardId = card.id
                                        closeCards()
                                    }
                            }
                        }
                    }
                    .padding()
                }
            }
            .ignoresSafeArea(.keyboard)
            .frame(width: geometry.size.width)
            .popup(isPresented: $cardsShown, backgroundOpacity: 0) {
                LearnCardsPopup(popupIsShown: $cardsShown, collectionName: $cardCollectionName, collectionIconLink: $cardCollectionIconLink, cardType: $cardType)
                    .environmentObject(cardCollections)
            }
            .onAppear {
                cardCollections.getCardCollections(token: authInfo.userInfo.token, userId: authInfo.userInfo.userId)
            }
            .onChange(of: cardsShown) { oldValue, newValue in
                if (newValue) {
                    cardCollections.getCardCollectionCards(collectionId: selectedCardId, token: authInfo.userInfo.token, userId: authInfo.userInfo.userId, cardType: cardType)
                }
            }
        }
    }
}

#Preview {
    @StateObject var profileInfo = VerificationViewModel(userService: UserService())
    
    return LearnListView(cardsShown: .constant(false), selectedCardId: .constant(0), cardCollectionName: .constant(""), cardCollectionIconLink: .constant(""))
        .environmentObject(profileInfo)
}
