//
//  DailyView.swift
//  Kofy
//
//  Created by Diego Gutierrez on 11/10/23.
//

import SwiftUI
import SwiftData

struct DailyView: View {
    @Environment(\.modelContext) var modelContext
    @Query var reminders: [RegisteredReminders]
    @Query var histories: [History]
    @EnvironmentObject var profileInfo: ProfileViewModel
    
    @State var confirmationIsShown = false
    
    @State var daysSinceLastVisit = 0
    
    @Binding var creditScreenIsShown: Bool
    
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
                                .onLongPressGesture {
                                    withAnimation {
                                        creditScreenIsShown.toggle()
                                    }
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
                    
                    VStack(alignment: .leading) {
                        Text("Recordatorios")
                            .foregroundStyle(Color(red: 0.956, green: 0.752, blue: 0.396))
                            .font(Font.system(size: 32, weight: .bold))
                            .padding([.leading], 25)
                            .padding([.top], 10)
                        
                        if (reminders.count != 0) {
                            ScrollView {
                                VStack {
                                    ForEach(reminders) { reminder in
                                        Button {
                                            confirmationIsShown = true
                                        } label: {
                                            ReminderButtonContent(reminder: ReminderResult(drugName: reminder.reminder.drugName, dosis: reminder.reminder.dosis, everyXHours: reminder.reminder.everyXHours), isDeletion: true)
                                        }
                                        .confirmationDialog("¿Deseas eliminar el recordatorio?", isPresented: $confirmationIsShown) {
                                            Button("Eliminar", role: .destructive) {
                                                NotificationManager.shared.deleteNotification(with: reminder.identifier)
                                                modelContext.delete(reminder)
                                            }
                                        }
                                    }
                                }
                            }
                            .padding([.leading, .trailing])
                        } else {
                            VStack(alignment: .leading) {
                                HStack(spacing: 10) {
                                    Image(systemName: "bell.fill")
                                        .resizable()
                                        .scaledToFit()
                                        .bold()
                                        .foregroundColor(.gray)
                                        .frame(width: 30)
                                    Text("No hay recordatorios")
                                        .bold()
                                        .font(Font.system(.title2))
                                }
                                .padding()
                                .padding([.leading, .trailing])
                                .background(.thinMaterial)
                                .clipShape(RoundedRectangle(cornerRadius: 8))
                            }
                            .frame(width: geometry.size.width)
//                            .padding([.leading], 25)
                        }
                    }
                    
                    VStack {
                        Color(red: 0.313, green: 0.313, blue: 0.313)
                            .frame(width: geometry.size.width / 1.3, height: 4)
                            .cornerRadius(.infinity)
                    }
                    .padding([.top, .bottom], 10)
                    
                    VStack {
//                        Text("Kofy")
//                            .frame(maxWidth: .infinity, alignment: .leading)
//                            .padding([.leading], 25)
//                            .font(Font.system(size: 32, weight: .bold))
                        
                        if (histories.count == 0) {
                            VStack {
                                Image("notFound")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 200)
                                Text("No hay registros actualmente")
                                    .bold()
                                    .font(Font.system(.title2))
                            }
                        } else {
                            VStack {
                                Text(String(daysSinceLastVisit) + (daysSinceLastVisit == 1 ? " día" : " días"))
                                    .font(Font.custom("ZenTokyoZoo-Regular", size: 75))
                                    .foregroundStyle(.white)
                                    .onAppear {
                                        let dateFormatter = DateFormatter()
                                        dateFormatter.dateFormat = "yyyy-MM-dd"
                                        let sessionDate = dateFormatter.date(from:histories.last!.sessionDate)
                                        let calendar = Calendar.current
                                        let components = calendar.dateComponents([.day], from: sessionDate ?? Date(), to: Date())
                                        daysSinceLastVisit = components.day ?? 0
                                    }
                                Text("Desde la última sesión")
                                    .bold()
                                    .font(Font.system(.title))
                            }
                        }
                        
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
    DailyView(creditScreenIsShown: .constant(true))
}
