//
//  ProfileView.swift
//  Kofy
//
//  Created by Diego Gutierrez on 11/10/23.
//

import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var authInfo: VerificationViewModel
    @EnvironmentObject var profileInfo: ProfileViewModel
    @EnvironmentObject var doctorInfo: DoctorsViewModel
    
    @State private var doctorListIsShown = false
    @Binding var updatePopupIsShown: Bool
    
    var body: some View {
        GeometryReader { geometry in
            NavigationStack {
                ZStack {
                    Color("BackgroundColor")
                        .ignoresSafeArea()
                    
                    VStack {
                        VStack(spacing: 0) {
                            Color(Color(red: 0.85, green: 0.85, blue: 0.85))
                                .ignoresSafeArea()
                                .frame(maxHeight: 0)
                            HStack {
                                Text("Tu perfil")
                                    .font(Font.system(size: 35, weight: .bold))
                                    .foregroundStyle(Color(red: 0.278, green: 0.278, blue: 0.278))
                                    .padding([.leading], 30)
                                Spacer()
                                
                                Button {
                                    authInfo.logout()
                                } label: {
                                    Image(systemName: "rectangle.portrait.and.arrow.right")
                                        .bold()
                                        .tint(.red)
                                        .padding([.trailing])
                                }
                            }
                            .padding(8)
                            .background(Color(red: 0.85, green: 0.85, blue: 0.85))
                            .clipShape(
                                .rect(
                                    bottomLeadingRadius: 20,
                                    bottomTrailingRadius: 20
                                )
                            )
                        }
                        
                        VStack {
                            Image("profile\(profileInfo.profileInfo.profilePicture)")
                                .resizable()
                                .scaledToFill()
                                .clipShape(/*@START_MENU_TOKEN@*/Circle()/*@END_MENU_TOKEN@*/)
                                .frame(width: 90, height: 90)
                                .padding([.trailing], 10)
                                .overlay(alignment: .bottomTrailing) {
                                    Button {
                                        updatePopupIsShown.toggle()
                                    } label: {
                                        Image(systemName: "pencil.circle.fill")
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 30)
                                            .tint(.white)
                                            .offset(x: -5)
                                    }
                                }
                            
                            VStack {
                                Text("\(profileInfo.profileInfo.names) \(profileInfo.profileInfo.lastNames)")
                                    .font(Font.system(.title, weight: .bold))
                                HStack {
                                    HStack {
                                        Image(systemName: "calendar")
                                            .foregroundStyle(.yellow)
                                        Text("\(profileInfo.profileInfo.birthday)")
                                            .font(Font.system(.caption))
                                            .bold()
                                    }
                                    .padding(8)
                                    .background(.thinMaterial)
                                    .foregroundStyle(.gray)
                                    .clipShape(RoundedRectangle(cornerRadius: 8))
                                    
                                    HStack {
                                        Image(systemName: "drop")
                                            .foregroundStyle(.red)
                                        Text("\(profileInfo.profileInfo.bloodType)")
                                            .font(Font.system(.caption))
                                            .bold()
                                    }
                                    .padding(8)
                                    .background(.thinMaterial)
                                    .foregroundStyle(.gray)
                                    .clipShape(RoundedRectangle(cornerRadius: 8))
                                    
                                    HStack {
                                        Image(systemName: "person.fill")
                                            .foregroundStyle(.blue)
                                        Text("\(profileInfo.profileInfo.gender)")
                                            .font(Font.system(.caption))
                                            .bold()
                                    }
                                    .padding(8)
                                    .background(.thinMaterial)
                                    .foregroundStyle(.gray)
                                    .clipShape(RoundedRectangle(cornerRadius: 8))
                                }
                                
                                HStack {
                                    HStack {
                                        Image(systemName: "ruler.fill")
                                            .foregroundStyle(.brown)
                                        Text("\(profileInfo.profileInfo.height) cm")
                                            .font(Font.system(.caption))
                                            .bold()
                                    }
                                    .padding(8)
                                    .background(.thinMaterial)
                                    .foregroundStyle(.gray)
                                    .clipShape(RoundedRectangle(cornerRadius: 8))
                                    
                                    if (profileInfo.profileInfo.allergies != "") {
                                        HStack {
                                            Image(systemName: "allergens")
                                                .foregroundStyle(.green)
                                            Text("\(profileInfo.profileInfo.allergies)")
                                                .font(Font.system(.caption))
                                                .bold()
                                        }
                                        .padding(8)
                                        .background(.thinMaterial)
                                        .foregroundStyle(.gray)
                                        .clipShape(RoundedRectangle(cornerRadius: 8))
                                    }
                                }
                                
                                if (profileInfo.profileInfo.diseases != "") {
                                    HStack {
                                        HStack {
                                            Image(systemName: "ivfluid.bag")
                                                .foregroundStyle(.purple)
                                            Text("\(profileInfo.profileInfo.diseases)")
                                                .font(Font.system(.caption))
                                                .bold()
                                        }
                                        .padding(8)
                                        .background(.thinMaterial)
                                        .foregroundStyle(.gray)
                                        .clipShape(RoundedRectangle(cornerRadius: 8))
                                    }
                                }
                            }
                        }
                        .padding()
                        .frame(width: geometry.size.width)
                        
                        Divider()
                            .padding([.leading, .trailing])
                        
                        HStack(spacing: 15) {
                            Image(systemName: "stethoscope")
                                .bold()
                                .foregroundStyle(.gray)
                            Text("Mis Doctores")
                                .font(Font.system(.title, weight: .bold))
                            
                            Spacer()
                            
                            Image(systemName: "chevron.right")
                                .bold()
                                .rotationEffect(Angle(degrees: doctorListIsShown ? 90 : 0))
                        }
                        .padding()
                        .padding([.trailing])
                        .frame(width: geometry.size.width, alignment: .leading)
                        .onTapGesture {
                            withAnimation {
                                doctorListIsShown.toggle()
                            }
                        }
                        
                        if (doctorListIsShown) {
                            ScrollView {
                                ForEach(doctorInfo.doctors) { doctor in
                                    NavigationLink {
                                        DoctorView(doctor: doctor)
                                            .environmentObject(doctorInfo)
                                            .environmentObject(authInfo)
                                    } label: {
                                        HStack {
                                            VStack(alignment: .leading) {
                                                Text(doctor.doctorName)
                                                    .foregroundStyle(.white)
                                                    .font(Font.system(.headline))
                                                Text(doctor.doctorFocus)
                                                    .font(Font.system(.caption))
                                                    .foregroundStyle(.gray)
                                            }
                                            .padding([.leading])
                                            
                                            Spacer()
                                            
                                            Image(systemName: "chevron.right")
                                                .padding([.trailing])
                                                .foregroundStyle(.white)
                                        }
                                        .padding(8)
                                        .background(.ultraThinMaterial)
                                        .clipShape(RoundedRectangle(cornerRadius: 8))
                                        .padding([.bottom], 3)
                                    }
                                }
                                .padding([.leading, .trailing])
                                .frame(width: geometry.size.width, alignment: .leading)
                            }
                            .scrollIndicators(.hidden)
                            .frame(width: geometry.size.width, alignment: .leading)
                        }
                        
                        
                        Spacer()
                    }
                }
                .padding(.bottom)
                .ignoresSafeArea(.keyboard)
                .frame(width: geometry.size.width)
                .onAppear {
                    UITableView.appearance().showsVerticalScrollIndicator = false
                }
            }
        }
    }
}

#Preview {
    @State var info = ProfileViewModel(userService: UserService())
    @State var shown = true
    
    return ProfileView(updatePopupIsShown: $shown)
        .environmentObject(info)
}
