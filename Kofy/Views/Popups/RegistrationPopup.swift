//
//  RegistrationPopup.swift
//  Kofy
//
//  Created by Diego Gutierrez on 18/10/23.
//

import SwiftUI
import HealthKit

struct RegistrationPopup: View {
    @EnvironmentObject var authInfo: VerificationViewModel
    @EnvironmentObject var profileInfo: ProfileViewModel
    @Environment(\.colorScheme) var colorScheme
    
    let profilePictureCount = 5
    
    // Personal data state variables
    @State private var names = ""
    @State private var lastNames = ""
    @State private var birthday = Date()
    @State private var gender = "Seleccionar"
    @State private var profilePicture = 0
    
    // Medical Stats state variables
    @State private var bloodType = HKCharacteristicTypeIdentifier.bloodType.rawValue
    @State private var height = 120
    @State private var weight: Float = 60.0
    @State private var allergies:[String] = []
    @State private var allergiesCount = 0
    @State private var diseases:[String] = []
    @State private var diseasesCount = 0
    
    // Popup variables
    @Binding var popupIsShown: Bool
    @State private var showImageSelectionSheet = false
    @State private var photoSelectionIsLibrary = true
    
    // Option variables
    let genders = ["Seleccionar", "Hombre", "Mujer", "Otro"]
    let bloodTypes = ["Seleccionar", "AB+", "AB-", "A+", "A-", "B+", "B-", "O+", "O-"]
    
    func dismissKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
    
    var body: some View {
        GeometryReader { geometry in
            NavigationStack {
                VStack {
                    VStack {
                        HStack {
                            Text("Tu perfil")
                                .foregroundStyle(.gray)
                                .padding()
                                .padding([.leading], 8)
                                .font(Font.system(size: 28))
                                .bold()
                                .onChange(of: popupIsShown, { oldValue, newValue in
                                    if (!newValue) {
                                        names = ""
                                    }
                                })
                            
                            Spacer()
                        }
                        .foregroundStyle(.black)
                        .frame(maxWidth: .infinity)
                        
                        VStack {
                            ZStack {
                                Image("profile\(profilePicture)")
                                    .resizable()
                                    .scaledToFill()
                                    .clipShape(Circle())
                                    .shadow(radius: 2)
                                    .frame(width: 100)
                                
                                Button {
                                    if (profilePicture + 1 <= profilePictureCount) {
                                        withAnimation {
                                            profilePicture += 1
                                        }
                                    } else {
                                        withAnimation {
                                            profilePicture = 0
                                        }
                                    }
                                } label: {
                                    ZStack {
                                        Color(.blue)
                                            .clipShape(/*@START_MENU_TOKEN@*/Circle()/*@END_MENU_TOKEN@*/)
                                        Image(systemName: "sparkles")
                                            .resizable()
                                            .foregroundStyle(.white)
                                            .bold()
                                            .scaledToFit()
                                            .frame(width: 15)
                                            .padding(10)
                                    }
                                    .frame(width: 10)
                                    .position(x: 90, y: 85)
                                }
                            }
                            .frame(width: 30, height: 100)
                            
                            HStack {
                                TextField("Nombres", text: $names, prompt: Text("Nombres").foregroundStyle(.gray))
                                    .foregroundStyle(.black)
                                    .padding()
                                    .background(Color(red: 0.976, green: 0.976, blue: 0.976))
                                    .clipShape(RoundedRectangle(cornerRadius: 10))
                                
                                TextField("Apellidos", text: $lastNames, prompt: Text("Apellidos").foregroundStyle(.gray))
                                    .foregroundStyle(.black)
                                    .padding()
                                    .background(Color(red: 0.976, green: 0.976, blue: 0.976))
                                    .clipShape(RoundedRectangle(cornerRadius: 10))
                            }
                            
                            HStack {
                                Text("Fecha de Nacimiento")
                                Spacer()
                                if (colorScheme == .dark) {
                                    DatePicker("Fecha de Nacimiento", selection: $birthday, displayedComponents: [.date])
                                        .labelsHidden()
                                        .colorInvert()
                                } else {
                                    DatePicker("Fecha de Nacimiento", selection: $birthday, displayedComponents: [.date])
                                        .labelsHidden()
                                }
                            }
                            .foregroundStyle(.gray)
                            .padding()
                            .background(Color(red: 0.976, green: 0.976, blue: 0.976))
                            .clipShape(RoundedRectangle(cornerRadius: 10))

                            
                            HStack {
                                Text("Genero")
                                Spacer()
                                Picker("Genero", selection: $gender) {
                                    ForEach(genders, id: \.self) {
                                        Text($0)
                                    }
                                }
                                .tint(.black)
                                .background(Color(red: 0.85, green: 0.85, blue: 0.86))
                                .clipShape(RoundedRectangle(cornerRadius: 8))
                            }
                            .foregroundStyle(.gray)
                            .padding()
                            .background(Color(red: 0.976, green: 0.976, blue: 0.976))
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                            .onChange(of: gender) { oldValue, newValue in
                                if (newValue == genders[0]) {
                                    gender = genders[1]
                                }
                            }
                            
                            HStack {
                                Text("Tipo de Sangre")
                                Spacer()
                                Picker("Tipo de Sangre", selection: $bloodType) {
                                    ForEach(bloodTypes, id: \.self) {
                                        Text($0)
                                    }
                                }
                                .tint(.black)
                                .background(Color(red: 0.85, green: 0.85, blue: 0.86))
                                .clipShape(RoundedRectangle(cornerRadius: 8))
                            }
                            .foregroundStyle(.gray)
                            .padding()
                            .background(Color(red: 0.976, green: 0.976, blue: 0.976))
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                            .onChange(of: bloodType) { oldValue, newValue in
                                if (newValue == bloodTypes[0]) {
                                    bloodType = bloodTypes[1]
                                }
                            }
                            
                            HStack {
                                Text("Altura")
                                Spacer()
                                CustomInputStepper(value: $height, lowerRange: 70, upperRange: 250)
                            }
                            .foregroundStyle(.gray)
                            .padding()
                            .background(Color(red: 0.976, green: 0.976, blue: 0.976))
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                            
                            
                            HStack(spacing: 10) {
                                NavigationLink {
                                    TagListView(tags:$allergies, tagNum: $allergiesCount, title: "Alergias", inputDescription: "Escribe tu alergia")
                                } label: {
                                    ZStack {
                                        Color(.white)
                                        Text("Alergias")
                                            .bold()
                                    }
                                    .clipShape(RoundedRectangle(cornerRadius: 10))
                                    .shadow(radius: 3)
                                    .overlay(alignment: .topTrailing, content: {
                                        NumberOverlay(value: $allergiesCount)
                                            .offset(x: 8, y: -8)
                                    })
                                }
                                
                                Spacer()
                                
                                NavigationLink {
                                    TagListView(tags: $diseases, tagNum: $diseasesCount, title: "Enfermedades", inputDescription: "Escribe tu enfermedad")
                                } label: {
                                    ZStack {
                                        Color(.white)
                                        Text("Enfermedades")
                                            .bold()
                                    }
                                    .clipShape(RoundedRectangle(cornerRadius: 10))
                                    .shadow(radius: 3)
                                    .overlay(alignment: .topTrailing, content: {
                                        NumberOverlay(value: $diseasesCount)
                                            .offset(x: 8, y: -8)
                                    })
                                }
                            }
                            .ignoresSafeArea(.keyboard)
                            .foregroundStyle(.gray)
                            .padding()
                            .background(Color(red: 0.976, green: 0.976, blue: 0.976))
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                            
                            
                        }
                        .padding()
                    
                        Button {
                            // REVISAR INPUTS AQUÍ
                            // GUARDAR PERFIL AQUÍ
                            dismissKeyboard()
                            
                            let allergiesFormatted = allergies.map{String($0)}.joined(separator: ",")
                            let diseasesFormatted = diseases.map{String($0)}.joined(separator: ",")
                            
                            let bodyData = ProfileInformation(userId: authInfo.userInfo.userId, names: names, last_names: lastNames, birthday: birthday, gender: gender, profile_picture: profilePicture, blood_type: bloodType, height: height, weight: weight, allergies: allergiesFormatted, diseases: diseasesFormatted)
                            
                            profileInfo.setProfileInfo(bodyData: bodyData, token: authInfo.userInfo.token, userId: authInfo.userInfo.userId)
                            
                            popupIsShown.toggle()
                        } label: {
                            VStack {
                                Text("Guardar")
                                    .bold()
                                    .foregroundStyle(.white)
                                    .font(Font.system(.title2))
                                    .padding([.top, .bottom], 10)
                            }
                            .frame(width: geometry.size.width / 2)
                            .background(.blue)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                        }
                        .ignoresSafeArea(.keyboard)
                        .padding(.bottom, geometry.safeAreaInsets.bottom)
                        
                    }
                    .frame(width: geometry.size.width)
                    .padding(.bottom, geometry.safeAreaInsets.bottom)
                    .background(.white)
                    .clipShape(RoundedCornersShape(radius: 16, corners: [.topLeft, .topRight]))
                }
                .shadow(color: .gray, radius: 15, x: 0,  y: 8)
                .edgesIgnoringSafeArea([.bottom])
            }
        }
    }
}

#Preview {
    ZStack {
        Color(.red)
        RegistrationPopup(popupIsShown: .constant(true))
    }
}
