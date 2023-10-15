//
//  NewDoctorPopupView.swift
//  Kofy
//
//  Created by Diego Gutierrez on 12/10/23.
//

import SwiftUI

struct NewDoctorPopupView: View {
    @Binding var popupIsShown: Bool
    
    // Form Inputs
    @State var doctorName = ""
    @State var doctorFocus = ""
    @State var doctorPhone = ""
    @State var doctorEmail = ""
    
    @State var cardSlideOffset = 0
    
    func dismissKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                Spacer()
                
                VStack {
                    HStack {
                        Text("Nuevo Doctor")
                            .foregroundStyle(.gray)
                            .padding()
                            .padding([.leading], 8)
                            .font(Font.system(size: 28))
                            .bold()
                            .onChange(of: popupIsShown, { oldValue, newValue in
                                if (!newValue) {
                                    doctorName = ""
                                    doctorFocus = ""
                                    doctorPhone = ""
                                    doctorEmail = ""
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
                        TextField("Nombre", text: $doctorName, prompt: Text("Nombre").foregroundStyle(.gray))
                            .foregroundStyle(.black)
                            .padding()
                            .background(Color(red: 0.976, green: 0.976, blue: 0.976))
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                        
                        TextField("Especialidad", text: $doctorFocus, prompt: Text("Especialidad").foregroundStyle(.gray))
                            .foregroundStyle(.black)
                            .padding()
                            .background(Color(red: 0.976, green: 0.976, blue: 0.976))
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                        
                        TextField("Teléfono", text: $doctorPhone, prompt: Text("Teléfono").foregroundStyle(.gray))
                            .foregroundStyle(.black)
                            .padding()
                            .background(Color(red: 0.976, green: 0.976, blue: 0.976))
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                        
                        TextField("Correo", text: $doctorEmail, prompt: Text("Correo").foregroundStyle(.gray))
                            .foregroundStyle(.black)
                            .padding()
                            .background(Color(red: 0.976, green: 0.976, blue: 0.976))
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                    }
                    .padding()
                    
                    Button {
                        // Registar doctor aquí
                        dismissKeyboard()
                        popupIsShown.toggle()
                    } label: {
                        VStack {
                            Text("Registrar")
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

#Preview {
    NewDoctorPopupView(popupIsShown: .constant(true))
}
