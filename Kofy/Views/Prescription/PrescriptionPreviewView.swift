//
//  PrescriptionPreviewView.swift
//  Kofy
//
//  Created by Diego Gutierrez on 18/11/23.
//

import SwiftUI

struct PrescriptionPreviewView: View {
    @EnvironmentObject var authInfo: VerificationViewModel
    @EnvironmentObject var sessionInfo: SummariesViewModel
    @EnvironmentObject var profileInfo: ProfileViewModel
    @Environment(\.dismiss) var dismiss
    @State var currentContent: [History]
    @State var prescriptionText = ""
    @State var scanning = false
    
    @State var hasRegistered = false
    @Binding var isDismissed: Bool
    
    @Binding var prescriptionIsShown: Bool
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Color("BackgroundColor")
                    .ignoresSafeArea()
                VStack {
                    Text("Receta")
                        .font(Font.system(.title))
                        .bold()
                        .padding([.leading])
                        .frame(width: geometry.size.width, alignment: .leading)
                    
                    VStack {
                        Color(red: 0.313, green: 0.313, blue: 0.313)
                            .frame(width: geometry.size.width / 1.2, height: 4)
                            .cornerRadius(.infinity)
                    }
                    .padding([.leading], 15)
                    .padding([.bottom], 2)
                    .frame(width: geometry.size.width, alignment: .leading)
                    
                    if (prescriptionText != "") {
                        Text("Edita el texto reconocido para solo incluir la información de los medicamentos.")
                            .foregroundStyle(.gray)
                            .padding([.leading, .trailing])
                            .frame(width: geometry.size.width, alignment: .leading)
                    }
                    
                    ScrollView {
                        TextField("", text: $prescriptionText, axis: .vertical)
                            .foregroundStyle(.white)
                            .font(Font.system(size: 25))
                    }
                    .padding()
                    
                    Spacer()
                    
                    if (prescriptionText == "") {
                        Button {
                            scanning.toggle()
                        } label: {
                            Text("Escanear")
                                .foregroundStyle(.white)
                                .padding()
                                .bold()
                                .background(.blue)
                                .clipShape(RoundedRectangle(cornerRadius: 14))
                        }
                    } else {
                        Button {
                            sessionInfo.prescriptionResults.explanations = []
                            sessionInfo.prescriptionResults.reminders = []
                            sessionInfo.getPrescriptionData(token: authInfo.userInfo.token, userId: authInfo.userInfo.userId, prescriptionText: prescriptionText, patientInfo: profileInfo.profileInfo.allergies + " // " + profileInfo.profileInfo.diseases, accessId: sessionInfo.sessionData.access_id)
                            
                            dismiss()
                            
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                prescriptionIsShown = true
                            }
                        } label: {
                            Text("Guardar")
                                .foregroundStyle(.white)
                                .padding()
                                .bold()
                                .background(.blue)
                                .clipShape(RoundedRectangle(cornerRadius: 14))
                        }
                    }
                }
            }
            .navigationBarBackButtonHidden()
            .frame(height: geometry.size.height)
            .sheet(isPresented: $scanning) {
                ScanDocumentView(recognizedText: self.$prescriptionText)
            }
            .onAppear {
                if (!hasRegistered) {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        scanning.toggle()
                    }
                }
            }
            .onChange(of: isDismissed) { oldValue, newValue in
                if (newValue) {
                    dismiss()
                }
            }
        }
    }
}

//#Preview {
//    PrescriptionPreviewView()
//}
