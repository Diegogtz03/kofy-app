//
//  IndividualTag.swift
//  Kofy
//
//  Created by Diego Gutierrez on 28/10/23.
//

import SwiftUI

struct IndividualTag: View {
    @Binding var tags: [String]
    @Binding var refreshTagList: Bool
    
    @Binding var tagNum: Int
    @State var tagContent: String
    @State var opacity = 1.0
    
    var body: some View {
        HStack {
            Text(tagContent)
                .foregroundStyle(.white)
            Image(systemName: "x.circle")
        }
        .padding(7)
        .opacity(opacity)
        .background(Color.blue.cornerRadius(.infinity))
        .clipShape(RoundedRectangle(cornerRadius: .infinity))
        .onTapGesture {
            opacity = 0.5
            tagNum -= 1
            withAnimation {
                tags = tags.filter({ $0 != tagContent })
                refreshTagList.toggle()
            }
        }
    }
}

#Preview {
    @State var tags = ["hello", "hi"]
    
    return IndividualTag(tags: $tags, refreshTagList: .constant(true), tagNum: .constant(0), tagContent: "Artritis")
}
