//
//  SignInView.swift
//  Kofy
//
//  Created by Diego Gutierrez on 04/10/23.
//

import SwiftUI
import CryptoKit

extension UINavigationController: UIGestureRecognizerDelegate {
    override open func viewDidLoad() {
        super.viewDidLoad()
        interactivePopGestureRecognizer?.delegate = self
    }

    public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return viewControllers.count > 1
    }
}

struct SignInView: View {
    @EnvironmentObject var authInfo: VerificationViewModel
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var btnIsDisabled = false
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
                                TextField("Correo", text: $email)
                                    .padding()
                                    .textInputAutocapitalization(.never)
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
                            btnIsDisabled.toggle()
                            
                            let hashedPassword = SHA512.hash(data: Data(password.utf8))
                            let hashString = hashedPassword.compactMap { String(format: "%02x", $0) }.joined()
                            authInfo.login(email: email, password: hashString)
                            
                            btnIsDisabled.toggle()
                        } label: {
                            Text("Iniciar Sesión")
                                .frame(width: geometry.size.width / 2.5)
                        }
                        .disabled(btnIsDisabled)
                        .padding()
                        .background(LinearGradient(gradient: Gradient(colors: [Color(red: 0.694, green: 0.376, blue: 0.941), Color(red: 0.533, green: 0.49, blue: 1)]), startPoint: .leading, endPoint: .trailing))
                        .cornerRadius(.infinity)
                        .foregroundStyle(.white)
                        .bold()
                        .overlay(
                            RoundedRectangle(cornerRadius: .infinity)
                                .stroke(.white, lineWidth: 3)
                        )
                        .opacity(btnIsDisabled ? 0.8 : 1)
                    }
                    
                    VStack {
                        Color(red: 0.313, green: 0.313, blue: 0.313)
                            .frame(width: geometry.size.width / 3, height: 4)
                            .cornerRadius(.infinity)
                    }
                    .padding([.top, .bottom], 10)
                    
                    Button {
                        print("Iniciar Sesión")
                    } label: {
                        HStack {
                            Image(systemName: "apple.logo")
                                .font(.title)
                            Text("Iniciar Sesión")
                                .frame(width: geometry.size.width / 3.5)
                        }
                        .padding()
                    }
                    .disabled(btnIsDisabled)
                    .background(.black)
                    .cornerRadius(.infinity)
                    .foregroundStyle(.white)
                    .bold()
                    .opacity(btnIsDisabled ? 0.8 : 1)
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

