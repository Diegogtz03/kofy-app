//
//  ReminderConfirmationPopupView.swift
//  Kofy
//
//  Created by Diego Gutierrez on 28/11/23.
//

import SwiftUI

struct ReminderConfirmationPopupView: View {
    @Environment(\.modelContext) var modelContext
    @EnvironmentObject var reminderContent: ReminderObservable
    
    @State private var drugName = ""
    @State private var drugDosis = ""
    @State private var everyXHours = 12
    @State var expirationDate = Date()
    @State var startTime = Date()
    
    @Environment(\.colorScheme) var colorScheme
    
    @Binding var popupIsShown: Bool
    @State var cardSlideOffset = 0
    
    @State var toast: Toast?
    
    func dismissKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
    
    func checkInputs() -> Bool {
        if (drugName == "" || drugDosis == "") {
            toast = Toast(style: .warning, appearPosition: .top, message: "Campos vacíos", topOffset: 0)
            return false
        }
        
        if (everyXHours < 1) {
            toast = Toast(style: .warning, appearPosition: .top, message: "Revise horario de medicamento", topOffset: 0)
            return false
        }
        
        var dateDifference = Calendar.current.dateComponents([.year, .month, .day], from: Date(), to: expirationDate).day ?? 0
        dateDifference += 1
        
        if (expirationDate == Date() || dateDifference <= 0) {
            toast = Toast(style: .warning, appearPosition: .top, message: "Fecha fin inválida", topOffset: 0)
            return false
        }
        
        let timeDifference = Calendar.current.dateComponents([.hour, .minute], from: Date(), to: startTime)
        
        if (timeDifference.hour ?? 0 < 0 || timeDifference.minute ?? 0 < 5) {
            toast = Toast(style: .warning, appearPosition: .top, message: "Hora de inicio inválida", topOffset: 0)
            return false
        }
        
        return true
    }
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                Spacer()
                
                VStack {
                    HStack {
                        Text("Nuevo recordatorio")
                            .foregroundStyle(.gray)
                            .padding()
                            .padding([.leading], 8)
                            .font(Font.system(size: 28))
                            .bold()
                            .onChange(of: popupIsShown, { oldValue, newValue in
                                if (!newValue) {
                                    drugName = ""
                                    drugDosis = ""
                                    everyXHours = 12
                                    expirationDate = Date()
                                } else {
                                    cardSlideOffset = 0
                                }
                            })
                        
                        Spacer()
                        
                        Button {
                            dismissKeyboard()
                            popupIsShown.toggle()
                        } label: {
                            Image(systemName: "x.circle")
                                .resizable()
                                .scaledToFit()
                                .foregroundStyle(.gray)
                                .frame(width: 25, height: 25)
                                .padding()
                        }
                    }
                    .foregroundStyle(.black)
                    .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/)
                    
                    VStack {
                        TextField("Medicamento", text: $drugName, prompt: Text("Medicamento").foregroundStyle(.gray))
                            .foregroundStyle(.black)
                            .padding()
                            .background(Color(red: 0.976, green: 0.976, blue: 0.976))
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                        
                        TextField("Dosis", text: $drugDosis, prompt: Text("Dosis").foregroundStyle(.gray))
                            .foregroundStyle(.black)
                            .padding()
                            .background(Color(red: 0.976, green: 0.976, blue: 0.976))
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                        
                        TextField("Cada X horas", value: $everyXHours, format: .number, prompt: Text("Cada X horas").foregroundStyle(.gray))
                            .foregroundStyle(.black)
                            .padding()
                            .background(Color(red: 0.976, green: 0.976, blue: 0.976))
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                            .keyboardType(.numberPad)
                        
                        HStack {
                            Text("Fecha Fin")
                            Spacer()
                            if (colorScheme == .dark) {
                                DatePicker("Fecha fin", selection: $expirationDate, displayedComponents: [.date])
                                    .labelsHidden()
                                    .colorInvert()
                            } else {
                                DatePicker("Fecha fin", selection: $expirationDate, displayedComponents: [.date])
                                    .labelsHidden()
                            }
                        }
                        .foregroundStyle(.gray)
                        .padding()
                        .background(Color(red: 0.976, green: 0.976, blue: 0.976))
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        
                        
                        HStack {
                            Text("Hora de Inicio")
                            Spacer()
                            if (colorScheme == .dark) {
                                DatePicker("Hora de inicio", selection: $startTime, displayedComponents: [.hourAndMinute])
                                    .labelsHidden()
                                    .colorInvert()
                            } else {
                                DatePicker("Hora de inicio", selection: $startTime, displayedComponents: [.hourAndMinute])
                                    .labelsHidden()
                            }
                        }
                        .foregroundStyle(.gray)
                        .padding()
                        .background(Color(red: 0.976, green: 0.976, blue: 0.976))
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                    }
                    .padding()
                    
                    Button {
                        if (checkInputs()) {
                            let timeDifference = Calendar.current.dateComponents([.hour, .minute], from: Date(), to: startTime)
                            
                            print("HOUR DIFFERENCE: \(timeDifference.hour ?? 0)")
                            print("MINUTE DIFFERENCE: \(timeDifference.minute ?? 0)")
                            
                            let secondWait = Double(everyXHours * 60) + Double(timeDifference.hour ?? 0 * 3600) + Double(timeDifference.minute ?? 0 * 60)
                            
                            let identifier = NotificationManager.shared.scheduleNotification(title: "Tus medicamentos", body: "Es hora de tomar \(drugName)", expirationDate: expirationDate, secondWait: secondWait, toast: $toast)
                            
                            let newReminder = RegisteredReminders(identifier: identifier, reminder: .init(drugName: drugName, dosis: drugDosis, everyXHours: everyXHours))
                            
                            modelContext.insert(newReminder)
                            
                            popupIsShown.toggle()
                        }
                    } label: {
                        VStack {
                            Text("Confirmar")
                                .bold()
                                .foregroundStyle(.white)
                                .font(Font.system(.title2))
                                .padding([.top, .bottom], 10)
                        }
                        .frame(width: geometry.size.width / 2)
                        .background(.blue)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                    }
                    .padding(.bottom, geometry.safeAreaInsets.bottom)
                    
                    
                    VStack {
                        EmptyView()
                    }
                    .frame(height: 220)
                }
                .frame(width: geometry.size.width)
                .padding(.bottom, geometry.safeAreaInsets.bottom)
                .background(.white)
                .clipShape(RoundedCornersShape(radius: 16, corners: [.topLeft, .topRight]))
                .offset(y: CGFloat(cardSlideOffset))
            }
            .toastView(toast: $toast)
            .onChange(of: popupIsShown, { oldValue, newValue in
                if (newValue) {
                    drugName = reminderContent.selectedDrugName
                    drugDosis = reminderContent.selectedDrugDosis
                    everyXHours = reminderContent.selectedDrugEveryXHours
                }
            })
            .shadow(color: .gray, radius: 15, x: 0,  y: 8)
            .edgesIgnoringSafeArea([.bottom])
            .gesture(
                DragGesture()
                    .onChanged { value in
                        if (value.translation.height > 0 && popupIsShown) {
                            cardSlideOffset = Int(value.translation.height)
                        }
                        
                        if value.translation.height > 100 {
                            dismissKeyboard()
                            popupIsShown = false
                        } else if (popupIsShown) {
                            withAnimation(Animation.easeInOut(duration: 0.2)) {
                                cardSlideOffset = 0
                            }
                        }
                    }
            )
        }
    }
}

//#Preview {
//    ReminderConfirmationPopupView()
//}
