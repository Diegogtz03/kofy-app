//
//  HomeView.swift
//  Kofy
//
//  Created by Diego Gutierrez on 04/10/23.
//

import SwiftUI

enum TabItems: Int, CaseIterable {
    case home = 0
    case history
    case add
    case doctors
    case profile
    
    var title: String {
        switch self {
        case .home:
            return "Diario"
        case .history:
            return "Historial"
        case .add:
            return "add"
        case .doctors:
            return "Aprende"
        case .profile:
            return "Perfil"
        }
    }
    
    var iconName: String {
        switch self {
        case .home:
            return "house"
        case .history:
            return "list.bullet.clipboard"
        case .add:
            return "plus"
        case .doctors:
            return "book"
        case .profile:
            return "person.fill"
        }
    }
}

extension HomeView {
    func CustomTabItem(imageName: String, title: String, isActive: Bool) -> some View {
            VStack(spacing: 10) {
                Spacer()
                
                Image(systemName: imageName)
                    .resizable()
                    .renderingMode(.template)
                    .scaledToFit()
                    .foregroundColor(isActive ? .blue : .gray)
                    .frame(width: 25, height: 25)
                
                Text(title)
                    .font(.system(size: 13))
                    .foregroundColor(isActive ? .blue : .gray)
                
                Spacer()
            }
            .frame(width: .infinity , height: 60)
    }
    
    func CustomAddButton(imageName: String, title: String, isActive: Bool) -> some View {
            ZStack{
                Image(systemName: imageName)
                    .resizable()
                    .renderingMode(.template)
                    .scaledToFit()
                    .foregroundColor(.white)
                    .frame(width: 25, height: 25)
            }
            .padding()
            .background(.red)
            .clipShape(Circle())
            .frame(width: .infinity , height: 60)
    }
}


struct HomeView: View {
    @Environment(\.modelContext) var modelContext
    
    @StateObject var profileInfo = ProfileViewModel(userService: UserService())
    @StateObject var sessionInfo = SummariesViewModel(userService: UserService())
    @EnvironmentObject var authInfo: VerificationViewModel
    @StateObject var doctorInfo = DoctorsViewModel(userService: UserService())
    @StateObject var historyVM = HistoryContentViewModel()
    @State var popupIsShown = false
    @State var registerPopupIsShown = false
    @State var profileUpdatePopupIsShown = false
    @State var selectedTab = 0
    @State var selectedTabTitle = ""
    
    // Learn View State Variables
    @State private var predictionIsShown = false
    @State private var learnCardsIsShown = false
    @State private var selectedCardId: Int = -1
    @State private var selectedCardTitle: String = ""
    @State private var selectedCardIcon: String = ""
    @State var cardsShown: Bool = false
    
    @State var prescriptionResultsShown = false
    @State var historyViewIsShown = false
    @State var historyDisabledTouch = false
    
    @State var creditScreenIsShown = false
    
    var body: some View {
        GeometryReader { geometry in
            if (!creditScreenIsShown) {
                NavigationStack {
                    ZStack(alignment: .bottom) {
                        TabView(selection: $selectedTab) {
                            DailyView(creditScreenIsShown: $creditScreenIsShown)
                                .tag(0)
                                .environmentObject(profileInfo)
                                .environment(\.modelContext, modelContext)
                            
                            HistoryListView(prescriptionViewIsShown: $prescriptionResultsShown, shown: $historyViewIsShown, disabledTouch: $historyDisabledTouch)
                                .tag(1)
                                .environmentObject(authInfo)
                                .environmentObject(sessionInfo)
                                .environmentObject(profileInfo)
                                .environment(\.modelContext, modelContext)
                            
                            LearnListView(cardsShown: $cardsShown, selectedCardId: $selectedCardId, cardCollectionName: $selectedCardTitle, cardCollectionIconLink: $selectedCardIcon)
                                .tag(3)
                                .environmentObject(authInfo)
                            
                            ProfileView(updatePopupIsShown: $profileUpdatePopupIsShown)
                                .tag(4)
                                .environmentObject(profileInfo)
                                .environmentObject(doctorInfo)
                        }
                        .ignoresSafeArea(.keyboard, edges: .bottom)
                        
                        ZStack {
                            HStack(spacing: 31) {
                                ForEach((TabItems.allCases), id: \.self) { item in
                                    Button {
                                        if (item.title != "add") {
                                            historyViewIsShown = false
                                            historyDisabledTouch = false
                                            selectedTabTitle = item.title
                                            selectedTab = item.rawValue
                                        } else {
                                            if (selectedTabTitle != "Aprende") {
                                                popupIsShown = true
                                            } else {
                                                predictionIsShown = true
                                            }
                                        }
                                    } label: {
                                        if (item.title != "add") {
                                            CustomTabItem(imageName: item.iconName, title: item.title, isActive: (selectedTab == item.rawValue))
                                        } else {
                                            CustomAddButton(imageName: (selectedTabTitle != "Aprende") ? item.iconName : "camera", title: item.title, isActive: (selectedTab == item.rawValue))
                                        }
                                    }
                                    .sensoryFeedback(trigger: popupIsShown) { oldValue, newValue in
                                        return .impact(flexibility: .solid, intensity: 0.5)
                                    }
                                }
                            }
                            .frame(width: geometry.size.width)
                            .padding([.top], 6)
                        }
                        .background(.ultraThinMaterial)
                        
                        CustomPredictionView(showingView: $predictionIsShown, cardsShown: $cardsShown, selectedCardId: $selectedCardId, selectedCardTitle: $selectedCardTitle, selectedCardIcon: $selectedCardIcon)
                            .frame(width: geometry.size.width, height: geometry.size.height)
                            .ignoresSafeArea()
                        
                    }
                    .ignoresSafeArea(.keyboard, edges: .bottom)
                    .frame(width: geometry.size.width, height: geometry.size.height)
                    .navigationDestination(isPresented: $prescriptionResultsShown) {
                        PrescriptionResultsView(prescriptionIsShown: $prescriptionResultsShown)
                            .environmentObject(sessionInfo)
                            .environment(\.modelContext, modelContext)
                            .frame(height: .infinity)
                    }
                    .popup(isPresented: $popupIsShown) {
                        BottomPopupView {
                            NewSessionPopupView(popupIsShown: $popupIsShown, prescriptionIsShown: $prescriptionResultsShown)
                                .environmentObject(doctorInfo)
                                .environmentObject(authInfo)
                                .environmentObject(sessionInfo)
                                .environmentObject(profileInfo)
                                .environment(\.modelContext, modelContext)
                        }
                    }
                    .popup(isPresented: $registerPopupIsShown) {
                        BottomPopupView {
                            RegistrationPopup(isUpdating: false, popupIsShown: $registerPopupIsShown)
                                .environmentObject(authInfo)
                                .environmentObject(profileInfo)
                        }
                    }
                    .popup(isPresented: $profileUpdatePopupIsShown) {
                        BottomPopupView {
                            RegistrationPopup(isUpdating: true, popupIsShown: $profileUpdatePopupIsShown)
                                .environmentObject(profileInfo)
                        }
                    }
                }
                .frame(width: geometry.size.width, height: geometry.size.height)
                .ignoresSafeArea(.keyboard, edges: [.bottom, .top])
                .onAppear {
                    // Get Profile
                    profileInfo.getProfileInfo(popupIsShown: $registerPopupIsShown, token: authInfo.userInfo.token, userId: authInfo.userInfo.userId)
                    doctorInfo.getDoctors(token: authInfo.userInfo.token, userId: authInfo.userInfo.userId)
                    
                    sessionInfo.updateModelContext(modelContext: modelContext)
                    
                    NotificationManager.shared.removeExpiredNotifications()
                }
            } else {
                CreditsView(isShown: $creditScreenIsShown)
            }
        }
    }
}

struct CustomPredictionView: View {
    @StateObject private var predictionStatus = PredictionStatus()
    @Binding var showingView: Bool
    @Binding var cardsShown: Bool
    @Binding var selectedCardId: Int
    @Binding var selectedCardTitle: String
    @Binding var selectedCardIcon: String

    var body: some View {
        GeometryReader { geometry in
            VStack {
                Spacer()
                if showingView {
                    PredictionCameraView(showingView: $showingView, cardsShown: $cardsShown, selectedCardId: $selectedCardId, selectedTitle: $selectedCardTitle, selectedImage: $selectedCardIcon)
                        .environmentObject(predictionStatus)
                        .frame(width: geometry.size.width, height: .infinity)
                        .ignoresSafeArea()
                        .transition(.move(edge: .bottom).combined(with: .opacity))
                }
            }
            .animation(.linear, value: showingView)
        }
    }
}

//#Preview {
//    HomeView()
//}
