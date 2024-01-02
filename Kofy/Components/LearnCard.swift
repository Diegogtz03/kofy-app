//
//  LearnCard.swift
//  Kofy
//
//  Created by Diego Gutierrez on 16/10/23.
//

import SwiftUI

struct LearnCard: View {
    @State var cardCollectionInfo: CardCollectionInfo
    
    var body: some View {
        ZStack {
            Color(.white)
            
            VStack {
                ZStack(alignment: .leading) {
                    Color(red: 0.956, green: 0.752, blue: 0.396)
                    Text(cardCollectionInfo.name)
                        .font(Font.system(size: 25))
                        .bold()
                        .padding()
                }
                .frame(height: 50)
                
                Spacer()
                
                AsyncImage(url: URL(string: cardCollectionInfo.icon)) { phase in
                    switch phase {
                    case .empty:
                        ProgressView()
                    case .success(let image):
                        image.resizable()
                            .scaledToFit()
                            .frame(height: .infinity)
                            .padding()
                    case .failure:
                        Image(systemName: "photo")
                    @unknown default:
                        EmptyView()
                    }
                }
            }
        }
        .frame(width: 170, height: 170)
        .mask(RoundedRectangle(cornerRadius: 25.0))
    }
}

#Preview {
    LearnCard(cardCollectionInfo: CardCollectionInfo(id: 0, name: "Inhalador", icon: "icon1"))
}
