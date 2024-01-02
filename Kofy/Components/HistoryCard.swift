//
//  HistoryCard.swift
//  Kofy
//
//  Created by Diego Gutierrez on 16/10/23.
//

import SwiftUI

struct HistoryCard: View {
    var namespace: Namespace.ID
    @Binding var shown: Bool
    
    @State var content: History
    var cardColors = ["CardColor0", "CardColor1", "CardColor2", "CardColor3", "CardColor4", "CardColor5"]
    
    var body: some View {
        // INICIO DE TARJETA
        ZStack(alignment: .leading) {
            LinearGradient(colors: [Color(cardColors[content.sessionColor]), Color(red: 0.34, green: 0.34, blue: 0.34)],
                           startPoint: .top,
                           endPoint: .center)
            .matchedGeometryEffect(id: "colorHeader", in: namespace, isSource: true)
            VStack(alignment: .leading, spacing: 3) {
                Text(content.sessionName)
                    .font(Font.system(size: 21, weight: .bold))
                    .matchedGeometryEffect(id: "title", in: namespace, isSource: true)
                Text(content.sessionDoctor)
                    .font(Font.system(size: 13))
                    .matchedGeometryEffect(id: "doctor", in: namespace, properties: .size, isSource: true)
                Text(content.sessionDate)
                    .font(Font.system(size: 13))
                    .foregroundStyle(.yellow)
                    .matchedGeometryEffect(id: "date", in: namespace, properties: .size, isSource: true)
            }
            .padding(10)
            .padding([.top], 60)
        }
        .frame(width: 170, height: 170)
        .mask(
            RoundedRectangle(cornerRadius: 25.0)
                .matchedGeometryEffect(id: "roundedShape", in: namespace)
        )
        // FIN DE TARJETA
    }
}

//#Preview {
//    @Namespace var namespace
//    
//    return HistoryCard(namespace: namespace, shown: .constant(true), content: History()
//}
