//
//  ReminderListView.swift
//  Kofy
//
//  Created by Diego Gutierrez on 04/10/23.
//

import SwiftUI

class Reminder {
    var name: String
    var quantity: String
    var description: String
    
    init(name: String, quantity: String, description: String) {
        self.name = name
        self.quantity = quantity
        self.description = description
   }
}

struct ReminderListView: View {
    var reminders = [Reminder(name: "Paracetamol", quantity: "500g", description: "En 2 horas"), Reminder(name: "Ibuprofeno", quantity: "1g", description: "En 8.5 horas")];
    
    var body: some View {
        GeometryReader { geometry in
            ScrollView {
                HStack {
                    Image("pillsIcon")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 40)
                        .padding([.leading, .trailing])
                    
                    VStack(alignment: .leading) {
                        Text(reminders[0].name)
                            .foregroundStyle(.black)
                            .font(Font.system(size: 21, weight: .bold))
                        Text(reminders[0].description)
                            .foregroundStyle(.black)
                            .font(Font.system(size: 15))
                    }
                    .frame(width: .infinity)
                    .padding([.top, .bottom])
                    
                    HStack {
                        Text(reminders[0].quantity)
                            .foregroundStyle(.black)
                            .font(Font.system(size: 21, weight: .bold))
                            .padding([.trailing])
                        
                        Image("arrowIcon")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 15)
                            .padding([.trailing])
                    }
                    .frame(maxWidth: .infinity, alignment: .trailing)
                }
                .frame(width: geometry.size.width / 1.15, alignment: .leading)
                .background(.white)
                .cornerRadius(10)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .inset(by: 2)
                        .stroke(Color(red: 0.56, green: 0.63, blue: 0.65), lineWidth: 4)
                )
                
                
                
                HStack {
                    Image("pillsIcon")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 40)
                        .padding([.leading, .trailing])
                    
                    VStack(alignment: .leading) {
                        Text(reminders[1].name)
                            .foregroundStyle(.black)
                            .font(Font.system(size: 21, weight: .bold))
                        Text(reminders[1].description)
                            .foregroundStyle(.black)
                            .font(Font.system(size: 15))
                    }
                    .frame(width: .infinity)
                    .padding([.top, .bottom])
                    
                    HStack {
                        Text(reminders[1].quantity)
                            .foregroundStyle(.black)
                            .font(Font.system(size: 21, weight: .bold))
                            .padding([.trailing])
                        
                        Image("arrowIcon")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 15)
                            .padding([.trailing])
                    }
                    .frame(maxWidth: .infinity, alignment: .trailing)
                }
                .frame(width: geometry.size.width / 1.15, alignment: .leading)
                .background(.white)
                .cornerRadius(10)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .inset(by: 2)
                        .stroke(Color(red: 0.56, green: 0.63, blue: 0.65), lineWidth: 4)
                )
            }
            .frame(width: geometry.size.width, alignment: .center)
        }
    }
}

#Preview {
    ReminderListView()
}
