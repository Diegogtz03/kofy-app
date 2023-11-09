//
//  SignUpView.swift
//  Kofy
//
//  Created by Diego Gutierrez on 04/10/23.
//

import SwiftUI
import CryptoKit

struct SignUpView: View {
    @EnvironmentObject var authInfo: VerificationViewModel
    @State private var username: String = ""
    @State private var mail: String = ""
    @State private var password: String = ""
    @Environment(\.dismiss) var dismiss
    
    func dismissKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Color("BackgroundColor")
                    .ignoresSafeArea()
                
                VStack {
                    VStack {
                        Image("KofyLogo")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 170)
                        Text("KOFY")
                            .font(Font.custom("ZenTokyoZoo-Regular", size: 50))
                            .foregroundStyle(.white)
                    }
                    .padding([.top], 50)
                    
                    Spacer()
                    
                    VStack(spacing: 30) {
                        VStack(spacing: 15) {
                            ZStack {
                                Color(red: 0.16, green: 0.16, blue: 0.16)
                                    .cornerRadius(10)
                                TextField("Usuario", text: $username)
                                    .padding()
                                    .autocorrectionDisabled()
                                    .textInputAutocapitalization(.never)
                            }
                            .frame(height: 60)
                            
                            ZStack {
                                Color(red: 0.16, green: 0.16, blue: 0.16)
                                    .cornerRadius(10)
                                TextField("Correo", text: $mail)
                                    .keyboardType(.emailAddress)
                                    .padding()
                                    .textInputAutocapitalization(.never)
                                    .autocorrectionDisabled()
                            }
                            .frame(height: 60)
                            
                            ZStack {
                                Color(red: 0.16, green: 0.16, blue: 0.16)
                                    .cornerRadius(10)
                                SecureField("Contraseña", text: $password)
                                    .padding()
                                    .textInputAutocapitalization(.never)
                            }
                            .frame(height: 60)
                        }
                        .frame(width: geometry.size.width * 0.75)
                        
                        Button {
                            dismissKeyboard()
                            let hashedPassword = SHA512.hash(data: Data(password.utf8))
                            let hashString = hashedPassword.compactMap { String(format: "%02x", $0) }.joined()
                            authInfo.signUp(username: username, email: mail, password: hashString, type: 0)
                        } label: {
                            Text("Registrarme")
                                .frame(width: geometry.size.width / 2.5)
                        }
                        .padding()
                        .background(LinearGradient(gradient: Gradient(colors: [Color(red: 0.694, green: 0.376, blue: 0.941), Color(red: 0.533, green: 0.49, blue: 1)]), startPoint: .leading, endPoint: .trailing))
                        .cornerRadius(.infinity)
                        .foregroundStyle(.white)
                        .bold()
                        .overlay(
                            RoundedRectangle(cornerRadius: .infinity)
                                .stroke(.white, lineWidth: 3)
                        )
                    }
                    
                    VStack {
                        Color(red: 0.313, green: 0.313, blue: 0.313)
                            .frame(width: geometry.size.width / 3, height: 4)
                            .cornerRadius(.infinity)
                    }
                    .padding([.top, .bottom], 10)
                    
                    Button {
                        print("Registrarme")
                    } label: {
                        HStack {
                            Image(systemName: "apple.logo")
                                .font(.title)
                            Text("Registrarme")
                                .frame(width: geometry.size.width / 3.5)
                        }
                        .padding()
                    }
                    .background(.black)
                    .cornerRadius(.infinity)
                    .foregroundStyle(.white)
                    .bold()
                }
            }
            .frame(width: geometry.size.width, height: geometry.size.height)
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button(action: {
                        dismiss()
                    }) {
                        Image(systemName: "chevron.backward")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 30, height: 30)
                            .bold()
                            .foregroundStyle(Color(red: 0.329, green: 0.329, blue: 0.329))
                    }
                }
            }
        }
    }
}

#Preview {
    SignUpView()
}
