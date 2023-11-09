//
//  DailyView.swift
//  Kofy
//
//  Created by Diego Gutierrez on 11/10/23.
//

import SwiftUI

struct DailyView: View {
    @EnvironmentObject var profileInfo: ProfileViewModel
    
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
                        HStack {
                            Text("Hola, \(profileInfo.profileInfo.names)")
                                .font(Font.system(size: 35, weight: .bold))
                                .foregroundStyle(Color(red: 0.278, green: 0.278, blue: 0.278))
                                .padding([.leading], 30)
                            Spacer()
                            Image("profile\(profileInfo.profileInfo.profilePicture)")
                                .resizable()
                                .scaledToFit()
                                .clipShape(/*@START_MENU_TOKEN@*/Circle()/*@END_MENU_TOKEN@*/)
                                .frame(width: 70)
                                .padding([.trailing], 10)
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
                    
                    VStack(alignment: .leading) {
                        Text("Recordatorios")
                            .foregroundStyle(Color(red: 0.956, green: 0.752, blue: 0.396))
                            .font(Font.system(size: 32, weight: .bold))
                            .padding([.leading], 25)
                            .padding([.top], 10)
                        
                        ReminderListView()
                    }
                    
                    VStack {
                        Color(red: 0.313, green: 0.313, blue: 0.313)
                            .frame(width: geometry.size.width / 1.3, height: 4)
                            .cornerRadius(.infinity)
                    }
                    .padding([.top, .bottom], 10)
                    
                    VStack {
                        Text("Kofy")
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding([.leading], 25)
                            .font(Font.system(size: 32, weight: .bold))
                        
                        Spacer()
                        
                    }
                }
            }
            .padding([.bottom])
            .ignoresSafeArea(.keyboard)
            .frame(width: geometry.size.width)
        }
    }
}

#Preview {
    DailyView()
}
