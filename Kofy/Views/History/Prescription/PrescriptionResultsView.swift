//
//  PrescriptionResultsView.swift
//  Kofy
//
//  Created by Diego Gutierrez on 31/10/23.
//

import SwiftUI

class ReminderObservable : ObservableObject {
    @Published var selectedDrugName: String
    @Published var selectedDrugDosis: String
    @Published var selectedDrugEveryXHours: Int
    
    init() {
        selectedDrugName = ""
        selectedDrugDosis = ""
        selectedDrugEveryXHours = 12
    }
}

struct PrescriptionResultsView: View {
    @EnvironmentObject var summariesInfo: SummariesViewModel
    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) var modelContext
    
    @StateObject var reminderContent = ReminderObservable()
    
    @Binding var prescriptionIsShown: Bool
    @State var popupIsShown = false
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Color("BackgroundColor")
                    .ignoresSafeArea()
                VStack(alignment: .leading) {
                    Text("Resultados")
                        .font(Font.system(.title))
                        .bold()
                        .foregroundStyle(.gray)
                        .padding([.leading])
                    
                    VStack {
                        Color(red: 0.313, green: 0.313, blue: 0.313)
                            .frame(width: geometry.size.width / 1.2, height: 4)
                            .cornerRadius(.infinity)
                    }
                    .padding([.leading], 15)
                    .padding([.bottom], 2)
                    .frame(width: geometry.size.width, alignment: .leading)
                    
                    // LISTA DE RESULTADOS
                    if (summariesInfo.prescriptionResults.explanations.count != 0) {
                        ScrollView {
                            VStack(alignment: .leading, spacing: 8) {
                                ForEach(0..<summariesInfo.prescriptionResults.explanations.count, id: \.self) { value in
                                    VStack(alignment: .leading, spacing: 8) {
                                        Text(summariesInfo.prescriptionResults.explanations[value].name)
                                            .bold()
                                            .font(Font.system(.title3))
                                            .foregroundStyle(.gray)
                                            .underline()
                                        
                                        VStack(alignment: .leading, spacing: 5) {
                                            ForEach(summariesInfo.prescriptionResults.explanations[value].explanation, id:\.self) { bullet in
                                                HStack {
                                                    Text("·")
                                                        .bold()
                                                    Text(bullet)
                                                }
                                            }
                                        }
                                    }
                                    .foregroundStyle(.white)
                                    .padding()
                                    .frame(width: geometry.size.width - 50, alignment: .leading)
                                    .background(.thinMaterial)
                                    .clipShape(RoundedRectangle(cornerRadius: 8))
                                    .padding([.leading, .trailing])
                                }
                            }
                        }
                        .padding([.leading, .trailing])
                        .frame(width: geometry.size.width)
                        .frame(maxHeight: 300)
                    } else {
//                        VStack(alignment: .center) {
//                            LoadingIndicator()
//                        }
//                        .frame(width: geometry.size.width)
                    }
                    
                    VStack {
                        Color(red: 0.313, green: 0.313, blue: 0.313)
                            .frame(width: geometry.size.width / 1.2, height: 4)
                            .cornerRadius(.infinity)
                    }
                    .padding([.leading], 15)
                    .padding([.bottom], 2)
                    .frame(width: geometry.size.width, alignment: .leading)
                    
                    // POSIBLES RECORDATORIOS
                    
                    Text("Posibles Recordatorios")
                        .font(Font.system(.title))
                        .bold()
                        .padding([.leading])
                    
                    if (summariesInfo.prescriptionResults.reminders.count != 0) {
                        ScrollView {
                            VStack {
                                ForEach(0..<summariesInfo.prescriptionResults.reminders.count, id: \.self) { value in
                                    Button {
                                        reminderContent.selectedDrugName = summariesInfo.prescriptionResults.reminders[value].drugName;
                                        reminderContent.selectedDrugDosis = summariesInfo.prescriptionResults.reminders[value].dosis;
                                        reminderContent.selectedDrugEveryXHours = summariesInfo.prescriptionResults.reminders[value].everyXHours;
                                        
                                         withAnimation {
                                             popupIsShown.toggle()
                                         }
                                    } label: {
                                        ReminderButtonContent(reminder: summariesInfo.prescriptionResults.reminders[value], isDeletion: false)
                                    }
                                }
                            }
                        }
                        .padding([.leading, .trailing])
                        .frame(width: geometry.size.width)
                        .frame(maxHeight: 300)
                    } else {
//                        VStack(alignment: .center) {
//                            LoadingIndicator()
//                        }
//                        .frame(width: geometry.size.width)
                    }
                    
                    Spacer()
                    
                    HStack(alignment:.center) {
                        Button {
                            dismiss()
                            prescriptionIsShown = false
                        } label: {
                            Text("Listo")
                                .foregroundStyle(.white)
                                .bold()
                                .font(Font.system(.title2))
                                .padding([.leading, .trailing])
                                .padding([.top, .bottom], 10)
                                .frame(width: 250)
                                .background(.blue)
                                .clipShape(RoundedRectangle(cornerRadius: 12))
                        }
                    }
                    .frame(width: geometry.size.width)
                }
                .frame(width: geometry.size.width, height: .infinity)
            }
            .frame(width: geometry.size.width, height: .infinity)
            .navigationBarBackButtonHidden()
            .popup(isPresented: $popupIsShown) {
                BottomPopupView {
                    ReminderConfirmationPopupView(popupIsShown: $popupIsShown)
                        .environmentObject(reminderContent)
                        .environment(\.modelContext, modelContext)
                }
            }
        }
    }
}

struct LoadingIndicator: View {
    @State var rotationAngle = 0.0
    
    var body: some View {
        VStack(alignment: .center) {
            ZStack {
                Image(systemName: "circle.dotted")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 50)
                    .rotationEffect(.degrees(rotationAngle))
                    .onAppear {
                        withAnimation(.linear(duration: 20)
                                .repeatForever(autoreverses: false)) {
                                    rotationAngle = 360.0
                        }
                    }
                Image(systemName: "doc.text")
            }
            
            Text("Cargando...")
                .font(Font.system(.title2))
                .bold()
        }
    }
}

//#Preview {
//    PrescriptionResultsView()
//}
