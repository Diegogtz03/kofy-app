//
//  NewSessionPopupView.swift
//  Kofy
//
//  Created by Diego Gutierrez on 11/10/23.
//

import SwiftUI

struct RoundedCornersShape: Shape {
    let radius: CGFloat
    let corners: UIRectCorner
    
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect,
                                byRoundingCorners: corners,
                                cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}

struct NewSessionPopupView: View {
    // Form Inputs
    @State var sessionName = ""
    @State var sessionDescription = ""
    @State var sessionDoctor = "Seleccionar"
    @State var sessionDate = Date()
    @State var doctors = ["Seleccionar", "Dr. Oscar", "Dra. Sandra", "Dr. Emilio", "Dr. Pepe", "-- Nuevo Doctor --"]
    
    @State private var currentPickedColor = 0;
    var cardColors = ["CardColor0", "CardColor1", "CardColor2", "CardColor3", "CardColor4", "CardColor5"]
    @State private var isRotating = false
    @State private var rotationAngle = 15
    @State private var longPressStarted = false
    
    @State private var newDoctorPopupShown = false
    @Binding var popupIsShown: Bool
    @FocusState private var isInitiallyFocused: Bool
    
    @State var cardSlideOffset = 0
    
    @State private var showTranscriptView = false
    @State private var showPrescriptionView = false
    
    func dismissKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
    
    var body: some View {
        GeometryReader { geometry in
//            NavigationStack {
                VStack {
                    Spacer()
                    VStack {
                        HStack {
                            TextField("Nombre de la sesión", text: $sessionName, prompt: Text("Nueva Cita").foregroundStyle(.gray))
                                .padding()
                                .padding([.leading], 10)
                                .font(Font.system(size: 28))
                                .bold()
                                .focused($isInitiallyFocused)
                                .onChange(of: popupIsShown, { oldValue, newValue in
                                    if (newValue) {
                                        cardSlideOffset = 0
                                        currentPickedColor = 0
                                        sessionName = ""
                                        sessionDescription = ""
                                        sessionDoctor = ""
                                        sessionDate = Date()
                                        
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                            isInitiallyFocused = true;
                                        }
                                    } else {
                                        dismissKeyboard();
                                        isInitiallyFocused = false;
                                    }
                                })
                            
                            Button {
                                withAnimation(Animation.easeInOut(duration: 0.2)) {
                                    if (!longPressStarted) {
                                        if (currentPickedColor != cardColors.count - 1) {
                                            currentPickedColor += 1;
                                        } else {
                                            currentPickedColor = 0;
                                        }
                                    }
                                }
                                
                                withAnimation(Animation.easeInOut(duration: 0.1).repeatCount(3)) {
                                    isRotating.toggle()
                                }
                            } label: {
                                Image(systemName: "paintpalette.fill")
                                    .renderingMode(.original)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 30, height: 30)
                                    .rotationEffect(Angle(degrees: isRotating ? Double(rotationAngle) : 0))
                            }
                            .simultaneousGesture(LongPressGesture().onEnded({ _ in
                                longPressStarted = true
                                
                                isRotating = false;
                                
                                let tempAngle = rotationAngle
                                rotationAngle = 360 - tempAngle
                                
                                withAnimation(Animation.easeInOut(duration: 0.3)) {
                                    isRotating = true;
                                } completion: {
                                    rotationAngle = tempAngle
                                }
                                
                                withAnimation(Animation.easeInOut(duration: 0.2)) {
                                    currentPickedColor = 0;
                                }
                            }))
                            .simultaneousGesture(TapGesture().onEnded({
                                longPressStarted = false
                            }))
                            
                            Spacer()
                            
                            Button {
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
                        .ignoresSafeArea(.keyboard)
                        .background(LinearGradient(colors: [Color(cardColors[currentPickedColor]), .white],
                                                   startPoint: .top,
                                                   endPoint: .bottom).padding([.bottom], -25))
                        .foregroundStyle(.black)
                        .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/)
                        .padding([.bottom], 10)
                        
                        
                        VStack(alignment: .leading, spacing: 10) {
                            TextField("Descripción de la sesión", text: $sessionDescription, prompt: Text("Descripción").foregroundStyle(.gray))
                                .foregroundStyle(.black)
                                .padding()
                                .background(Color(red: 0.976, green: 0.976, blue: 0.976))
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                                .padding([.leading, .trailing])
                            
                            HStack {
                                Text("Doctor")
                                    .foregroundStyle(.gray)
                                
                                Spacer()
                                
                                Picker("Doctor", selection: $sessionDoctor) {
                                    ForEach(doctors, id: \.self) { doctor in
                                        Text(doctor)
                                    }
                                }
                                .tint(.gray)
                                .background(Color(red: 0.87, green: 0.87, blue: 0.88))
                                .pickerStyle(.menu)
                                .clipShape(RoundedRectangle(cornerRadius: 8))
                                .sensoryFeedback(trigger: newDoctorPopupShown) { oldValue, newValue in
                                    return .impact(flexibility: .solid, intensity: 0.5)
                                }
                                .onTapGesture(perform: {
                                    dismissKeyboard()
                                })
                                .onChange(of: sessionDoctor) { oldValue, newValue in
                                    if (newValue == "-- Nuevo Doctor --") {
                                        dismissKeyboard()
                                        sessionDoctor = "Seleccionar"
                                        newDoctorPopupShown = true;
                                    }
                                }
                            }
                            .ignoresSafeArea(.keyboard)
                            .foregroundStyle(.black)
                            .padding()
                            .background(Color(red: 0.976, green: 0.976, blue: 0.976))
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                            .padding([.leading, .trailing])
                            
                            DatePicker("Fecha de la sesión", selection: $sessionDate, displayedComponents: [.date])
                                .foregroundStyle(.gray)
                                .padding()
                                .background(Color(red: 0.976, green: 0.976, blue: 0.976))
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                                .padding([.leading, .trailing])
                                .onTapGesture(perform: {
                                    dismissKeyboard()
                                })
                        }
                        .ignoresSafeArea(.keyboard)
                        .padding([.bottom], 20)
                        
                        HStack(spacing: 30) {
                            Button {
//                                SpeechSessionView()
                            } label: {
                                HStack {
                                    Image(systemName: "person.2.wave.2.fill")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 30)
                                        .foregroundStyle(.gray)
                                    Text("Escucha")
                                        .font(Font.system(.title3))
                                        .bold()
                                }
                                .padding(9)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 13)
                                        .stroke(Color.blue, lineWidth: 3)
                                )
                            }
                            .overlay(alignment: .trailing, content: {
                                Image(systemName: "plus.circle.fill")
                                    .resizable()
                                    .renderingMode(.original)
                                    .scaledToFit()
                                    .frame(width: 25)
                                    .padding([.top], -30)
                                    .padding([.trailing], -8)
                            })
                            
                            Button {
//                                SpeechSessionView()
                            } label: {
                                HStack {
                                    Image(systemName: "list.bullet.clipboard.fill")
                                        .resizable()
                                        .frame(width: 15, height: 20)
                                        .scaledToFit()
                                        .foregroundStyle(.gray)
                                    Text("Receta")
                                        .font(Font.system(.title3))
                                        .bold()
                                }
                                .padding(9)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 13)
                                        .stroke(Color.blue, lineWidth: 3)
                                )
                            }
                            .overlay(alignment: .trailing, content: {
                                Image(systemName: "plus.circle.fill")
                                    .resizable()
                                    .renderingMode(.original)
                                    .scaledToFit()
                                    .frame(width: 25)
                                    .padding([.top], -30)
                                    .padding([.trailing], -8)
                            })
                        }
                        .ignoresSafeArea(.keyboard)
                        .frame(width: geometry.size.width)
                        
                        VStack {
                            EmptyView()
                        }
                        .frame(height: 300)
                    }
                    .ignoresSafeArea(.keyboard)
                    .background(.white)
                    .clipShape(RoundedCornersShape(radius: 16, corners: [.topLeft, .topRight]))
                    .offset(y: CGFloat(cardSlideOffset))
                }
                .shadow(color: .gray, radius: 15, x: 0,  y: 8)
                //            .ignoresSafeArea(.keyboard)
                //            .ignoresSafeArea(.all)
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
                .popup(isPresented: $newDoctorPopupShown) {
                    NewDoctorPopupView(popupIsShown: $newDoctorPopupShown)
                }
//            }
        }
    }
}

#Preview {
    NewSessionPopupView(popupIsShown: .constant(true))
}
