//
//  LandingView.swift
//  Kofy
//
//  Created by Diego Gutierrez on 03/10/23.
//

import SwiftUI

struct LandingView: View {
    @EnvironmentObject var authInfo: VerificationViewModel
    
    var body: some View {
        GeometryReader { geometry in
            NavigationStack {
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
                        
                        VStack(spacing: 20) {
                            
                            NavigationLink {
                                SignInView()
                                    .environmentObject(authInfo)
                            } label: {
                                // Login Button
                                Text("Iniciar Sesión")
                                    .frame(width: geometry.size.width / 2)
                                    .padding()
                                    .background(Color(red: 0.156, green: 0.156, blue: 0.156))
                                    .cornerRadius(.infinity)
                                    .foregroundStyle(.white)
                                    .bold()
                                    .overlay(
                                        RoundedRectangle(cornerRadius: .infinity)
                                            .stroke(.white, lineWidth: 3)
                                    )
                            }
                            
                            NavigationLink {
                                SignUpView()
                                    .environmentObject(authInfo)
                            } label: {
                                // Sign Up Button
                                Text("Registrarme")
                                    .frame(width: geometry.size.width / 2)
                                    .padding()
                                    .background(Color(red: 0.556, green: 0.478, blue: 0.996))
                                    .cornerRadius(.infinity)
                                    .foregroundStyle(.white)
                                    .bold()
                                    .overlay(
                                        RoundedRectangle(cornerRadius: .infinity)
                                            .stroke(.white, lineWidth: 3)
                                    )
                            }
                        }
                        .padding([.bottom], 30)
                        .frame(width: geometry.size.width / 2)
                    }
                }
                .background()
            }
            .frame(width: geometry.size.width, height: geometry.size.height)
        }
    }
}

