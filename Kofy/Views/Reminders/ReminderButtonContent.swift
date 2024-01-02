//
//  ReminderButtonContent.swift
//  Kofy
//
//  Created by Diego Gutierrez on 28/11/23.
//

import SwiftUI

struct ReminderButtonContent: View {
    @State var reminder: ReminderResult
    @State var isDeletion: Bool
    
    var body: some View {
        HStack {
            Image("pillsIcon")
                .resizable()
                .scaledToFit()
                .frame(width: 40, height: 40)
                .padding([.leading, .trailing])
            
            VStack(alignment: .leading) {
                Text(reminder.drugName)
                    .foregroundStyle(.black)
                    .font(Font.system(size: 21, weight: .bold))
                Text(reminder.dosis + (isDeletion ? " cada \(reminder.everyXHours) hora(s)" : ""))
                    .foregroundStyle(.black)
                    .font(Font.system(size: 15))
            }
            .frame(width: .infinity)
            .padding([.top, .bottom])
            
            HStack {
                Image(systemName: isDeletion ? "minus.circle" : "plus")
                    .resizable()
                    .scaledToFit()
                    .bold()
                    .foregroundStyle(.black)
                    .frame(width: 30, height: 30)
                    .padding([.trailing])
            }
            .frame(maxWidth: .infinity, alignment: .trailing)
        }
        .frame(alignment: .leading)
        .background(.white)
        .cornerRadius(10)
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .inset(by: 2)
                .stroke(Color(red: 0.56, green: 0.63, blue: 0.65), lineWidth: 4)
        )
    }
}

//#Preview {
//    ReminderButtonContent()
//}
