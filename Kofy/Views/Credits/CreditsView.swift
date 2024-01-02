//
//  CreditsView.swift
//  Kofy
//
//  Created by Diego Gutierrez on 13/12/23.
//

import SwiftUI

struct CreditsView: View {
    @Binding var isShown: Bool
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Color("BackgroundColor")
                    .ignoresSafeArea()
                
                VStack {
                    HStack() {
                        Button {
                            withAnimation {
                                isShown.toggle()
                            }
                        } label: {
                            Image(systemName: "chevron.backward")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 30, height: 30)
                                .bold()
                                .foregroundStyle(Color(red: 0.329, green: 0.329, blue: 0.329))
                        }
                        .padding([.leading], 20)
                        
                        Spacer()
                    }
                    .frame(width: geometry.size.width)
                    
                    Image("KofyLogo")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 150)
                        .padding([.top])
                    
                    Text("créditos")
                        .underline()
                        .font(Font.custom("ZenTokyoZoo-Regular", size: 55))
                        .padding([.bottom], 5)
                        .foregroundStyle(.white)
                    
                    VStack(spacing: 8) {
                        Text("Diego Gutiérrez Treviño")
                        Text("Roberto José García Ríos")
                        Text("Scarlet Soto")
                        Text("Andrea San Martin Vital")
                        Text("Jose Antonio Ramirez Oliva")
                    }
                    .font(Font.system(.title3))
                    
                    Spacer()
                }
                .foregroundStyle(.gray)
                .bold()
            }
        }
    }
}

#Preview {
    CreditsView(isShown: .constant(true))
}
