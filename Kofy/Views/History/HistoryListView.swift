//
//  HistoryListView.swift
//  Kofy
//
//  Created by Diego Gutierrez on 09/10/23.
//

import SwiftUI

struct HistoryListView: View {
    @EnvironmentObject var profileInfo: ProfileViewModel
    @EnvironmentObject var historyVM : HistoryContentViewModel
    
    var history: [HistoryContentModel]
    var filteredHistory:[HistoryContentModel] {
        history.filter { content in
            (!filtersShown || content.description.lowercased().hasPrefix(searchText.lowercased()) || content.doctor.lowercased().hasPrefix(searchText.lowercased()))
        }
    }
    
    @State var shown = false
    @State var currentNamespace = Namespace().wrappedValue
    @State var selectedCard = 0
    
    let columns = [GridItem(.flexible()), GridItem(.flexible())]

    var cardColors = ["CardColor0", "CardColor1", "CardColor2", "CardColor3", "CardColor4", "CardColor5"]
    
    @State private var cardNamespaces:[Namespace.ID] = []
    @State private var searchText = ""
    @State private var searchDate = Date()
    @State private var filtersShown = false
    @State private var disabledTouch = false
    
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
                                Text("Historial")
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
                                HStack {
                                    TextField("Busqueda", text: $searchText, prompt: Text("Busqueda").foregroundStyle(.gray))
                                        .padding(7)
                                        .background(.white)
                                        .foregroundStyle(.black)
                                        .clipShape(RoundedRectangle(cornerRadius: 8))
                                        .frame(width: 200)
                                    
                                    DatePicker("", selection: $searchDate, displayedComponents: [.date])
                                }
                                .padding([.leading, .trailing])
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
                    
                    NavigationStack {
                        ZStack {
                            Color("BackgroundColor")
                            ScrollView {
                                LazyVGrid(columns: columns, alignment: .center, spacing: 15) {
                                    ForEach(Array(filteredHistory.enumerated()), id: \.element.id) { (index, card) in
                                        if (cardNamespaces.count != 0) {
                                            HistoryCard(namespace: cardNamespaces[index], shown: $shown, content: card)
                                                .onTapGesture {
                                                    if (!disabledTouch) {
                                                        selectedCard = index
                                                        disabledTouch = true
                                                        withAnimation {
                                                            shown.toggle()
                                                        }
                                                    }
                                                }
                                        }
                                    }
                                }
                            }
                            .padding()
                        }
                        .ignoresSafeArea()
                    }
                }
                
                if (shown) {
                    HistoryView(namespace: cardNamespaces[selectedCard], shown: $shown, disabledTouch: $disabledTouch, content: filteredHistory[selectedCard])
                }
            }
            .ignoresSafeArea(.keyboard)
            .frame(width: geometry.size.width)
            .onAppear() {
                for _ in 1...history.count {
                    let newNamespace = Namespace().wrappedValue
                    cardNamespaces.append(newNamespace)
                }
            }
        }
    }
}

#Preview {
    HistoryListView(history: [HistoryContentModel(doctor: "Dr. José Luis", description: "Cita con dermatólogo", date: "3/10/2023", color: 1), HistoryContentModel(doctor: "Dr. José Luis", description: "Cita con dermatólogo", date: "3/10/2023", color: 2), HistoryContentModel(doctor: "Dr. José Luis", description: "Cita con dermatólogo", date: "3/10/2023", color: 3), HistoryContentModel(doctor: "Dra. Sandra", description: "Cita con dermatólogo", date: "3/10/2023", color: 4)])
}
