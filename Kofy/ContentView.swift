//
//  ContentView.swift
//  Kofy
//
//  Created by Diego Gutierrez on 03/10/23.
//

import SwiftUI

struct ContentView: View {
    @StateObject var authInfo = VerificationViewModel(userService: UserService())
    @State var splashIsActive: Bool = true;

    var body: some View {
        ZStack {
            if self.splashIsActive {
                SplashView()
                    .onTapGesture {
                        withAnimation {
                            self.splashIsActive = false;
                        }
                    }
            } else {
                if authInfo.isAuthenticated {
                    HomeView()
                        .environmentObject(authInfo)
                } else {
                    LandingView()
                        .environmentObject(authInfo)
                }
            }
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 8) {
                withAnimation {
                    self.splashIsActive = false;
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
