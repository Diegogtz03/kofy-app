//
//  DoctorView.swift
//  Kofy
//
//  Created by Diego Gutierrez on 16/11/23.
//

import SwiftUI

struct DoctorView: View {
    @EnvironmentObject var authInfo: VerificationViewModel
    @EnvironmentObject var doctorInfo: DoctorsViewModel
    
    @State var doctor: DoctorInfo
    
    @State private var doctorName = ""
    @State private var doctorFocus = ""
    @State private var doctorPhone = ""
    @State private var doctorEmail = ""
    @State private var hasChanged = false
    
    @State private var isEditing = false
    
    @Environment(\.dismiss) var dismiss
    
    @Namespace var iconNamespace
    
    @State private var toast: Toast? = nil
    
    func dismissKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
    
    func validateEmail() -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: doctorEmail)
    }
    
    func checkInputs() -> Bool {
        if (doctorName == "" || doctorFocus == "") {
            toast = Toast(style: .warning, appearPosition: .bottom, message: "Campos vacíos", width: 350)
            return false
        }
        
        if (doctorPhone != "" && !(doctorPhone.count < 15 && doctorPhone.count >= 10)) {
            toast = Toast(style: .warning, appearPosition: .bottom, message: "Teléfono inválido", width: 350)
            return false
        }
        
        if (doctorEmail != "" && !validateEmail()) {
            toast = Toast(style: .warning, appearPosition: .bottom, message: "Correo inválido", width: 350)
            return false
        }
        
        return true
    }
    
    func checkSave() -> Bool {
        if (doctorName != doctor.doctorName) {
            return true
        } else if (doctorFocus != doctor.doctorFocus) {
            return true
        } else if (doctorPhone != doctor.doctorPhone) {
            return true
        } else if (doctorEmail != doctor.doctorEmail) {
            return true
        } else {
            return false
        }
    }
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Color("BackgroundColor")
                    .ignoresSafeArea()
                
                VStack {
                    HStack {
                        Button {
                            dismissKeyboard()
                            dismiss()
                            
                            if (hasChanged) {
                                doctorInfo.getDoctors(token: authInfo.userInfo.token, userId: authInfo.userInfo.userId)
                            }
                        } label: {
                            Image(systemName: "chevron.left")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 15)
                                .bold()
                                .foregroundStyle(.white)
                                .padding()
                                .padding([.leading], 15)
                        }
                        
                        Spacer()
                        
                        Text("Doctores")
                            .bold()
                            .font(Font.system(.largeTitle))
                            .foregroundStyle(.gray)
                        
                        Spacer()
                        
                        Button {
                            dismissKeyboard()
                            
                            if isEditing {
                                if checkSave() {
                                    if checkInputs() {
                                        // SAVE DATA
                                        let bodyData = DoctorInfo(id: doctor.id, doctorName: doctorName, doctorFocus: doctorFocus, doctorPhone: doctorPhone, doctorEmail: doctorEmail)
                                        
                                        doctorInfo.updateDoctor(token: authInfo.userInfo.token, userId: authInfo.userInfo.userId, bodyData: bodyData, currentDoctor: $doctor, toast: $toast)
                                        
                                        hasChanged = true
                                        
                                        withAnimation {
                                            isEditing.toggle()
                                        }
                                    }
                                } else {
                                    withAnimation {
                                        isEditing.toggle()
                                    }
                                }
                            } else {
                                withAnimation {
                                    isEditing.toggle()
                                }
                            }
                        } label: {
                            Image(systemName: isEditing ? "checkmark" : "pencil")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 23)
                                .bold()
                                .foregroundStyle(isEditing ? .blue : .white)
                                .padding()
                                .padding([.trailing], 15)
                        }
                        .contentTransition(.symbolEffect(.replace))
                    }
                    .frame(width: geometry.size.width)
                    
                    
                    // Line Spacer
                    VStack {
                        Color(red: 0.313, green: 0.313, blue: 0.313)
                            .frame(width: geometry.size.width / 1.1, height: 4)
                            .cornerRadius(.infinity)
                    }
                    
                    VStack(alignment: .leading, spacing: isEditing ? 10 : 20) {
                        HStack {
                            Image(systemName: "person.fill")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 23)
                                .foregroundStyle(isEditing ? .blue : .cardColor1)
                                .padding([.trailing])
                            if (!isEditing) {
                                Text(doctor.doctorName)
                                    .font(Font.system(size: 28, weight: .bold))
                                    .foregroundStyle(.white)
                            } else {
                                TextField("Nombre de Doctor", text: $doctorName, prompt: Text("Nombre").foregroundStyle(.gray))
                                    .foregroundStyle(.white)
                                    .padding()
                                    .background(.thinMaterial)
                                    .clipShape(RoundedRectangle(cornerRadius: 10))
                                    .padding([.trailing])
                            }
                        }
                        .padding([.leading], 25)
                    
                        HStack {
                            Image(systemName: "stethoscope")
                                .resizable()
                                .scaledToFit()
                                .bold()
                                .frame(width: 23)
                                .foregroundStyle(isEditing ? .blue : .cardColor1)
                                .padding([.trailing])
                            if (!isEditing) {
                                Text(doctor.doctorFocus)
                                    .font(Font.system(size: 20))
                                    .foregroundStyle(.white)
                            } else {
                                TextField("Especialidad de Doctor/a", text: $doctorFocus, prompt: Text("Especialidad").foregroundStyle(.gray))
                                    .foregroundStyle(.white)
                                    .padding()
                                    .background(.thinMaterial)
                                    .clipShape(RoundedRectangle(cornerRadius: 10))
                                    .padding([.trailing])
                            }
                        }
                        .padding([.leading], 25)
                        
                        if (!isEditing) {
                            if (doctorPhone != "") {
                                Button {
                                    let telephone = "tel://\(doctor.doctorPhone)"
                                    guard let url = URL(string: telephone) else { return }
                                    UIApplication.shared.open(url)
                                } label: {
                                    HStack {
                                        Image(systemName: "phone.fill")
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 23)
                                            .foregroundStyle(.cardColor1)
                                            .padding([.trailing])
                                            .matchedGeometryEffect(id: "phone", in: iconNamespace)
                                        Text(doctor.doctorPhone)
                                            .font(Font.system(size: 20))
                                            .foregroundStyle(.white)
                                    }
                                    .padding([.leading], 25)
                                }
                            }
                        } else {
                            HStack {
                                Image(systemName: "phone.fill")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 23)
                                    .foregroundStyle(.blue)
                                    .padding([.trailing])
                                    .matchedGeometryEffect(id: "phone", in: iconNamespace)
                                TextField("Teléfono de Doctor/a", text: $doctorPhone, prompt: Text("Teléfono").foregroundStyle(.gray))
                                    .foregroundStyle(.white)
                                    .padding()
                                    .background(.thinMaterial)
                                    .clipShape(RoundedRectangle(cornerRadius: 10))
                                    .padding([.trailing])
                                    .keyboardType(.numberPad)
                            }
                            .padding([.leading], 25)
                        }
                        
                        
                        if (!isEditing) {
                            if (doctorEmail != "") {
                                Link(destination: URL(string: "mailto:\(doctor.doctorEmail)")!) {
                                    HStack {
                                        Image(systemName: "envelope.fill")
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 23)
                                            .foregroundStyle(.cardColor1)
                                            .padding([.trailing])
                                            .matchedGeometryEffect(id: "mail", in: iconNamespace)
                                        Text(doctor.doctorEmail)
                                            .font(Font.system(size: 20))
                                            .foregroundStyle(.white)
                                    }
                                    .padding([.leading], 25)
                                }
                            }
                        } else {
                            HStack {
                                Image(systemName: "envelope.fill")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 23)
                                    .foregroundStyle(.blue)
                                    .padding([.trailing])
                                    .matchedGeometryEffect(id: "mail", in: iconNamespace)
                                TextField("Correo de Doctor/a", text: $doctorEmail, prompt: Text("Correo").foregroundStyle(.gray))
                                    .foregroundStyle(.white)
                                    .padding()
                                    .background(.thinMaterial)
                                    .clipShape(RoundedRectangle(cornerRadius: 10))
                                    .padding([.trailing])
                                    .textInputAutocapitalization(.never)
                            }
                            .padding([.leading], 25)
                        }
                        
                        Spacer()
                    }
                    .frame(width: geometry.size.width, alignment: .leading)
                    .padding()
                    .padding([.leading, .trailing])

                }
            }
            .toastView(toast: $toast)
            .navigationBarBackButtonHidden()
            .frame(width: geometry.size.width)
            .onAppear {
                doctorName = doctor.doctorName;
                doctorFocus = doctor.doctorFocus;
                doctorPhone = doctor.doctorPhone;
                doctorEmail = doctor.doctorEmail;
            }
            .onChange(of: isEditing) { before, after in
                if (after) {
                    doctorName = doctor.doctorName;
                    doctorFocus = doctor.doctorFocus;
                    doctorPhone = doctor.doctorPhone;
                    doctorEmail = doctor.doctorEmail;
                }
            }
        }
    }
}

#Preview {
    @State var doctor = DoctorInfo(id: 0, doctorName: "Oscar Gutierrez", doctorFocus: "Pediatra", doctorPhone: "8993893893", doctorEmail: "diego@gmail.com")
    
    return DoctorView(doctor: doctor)
}
