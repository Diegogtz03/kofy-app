//
//  VerificationViewModel.swift
//  Kofy
//
//  Created by Diego Gutierrez on 30/10/23.
//

import SwiftUI
import Combine

class VerificationViewModel : ObservableObject {
    @Published var isAuthenticated : Bool
    @Published var userInfo : VerificationModel
    @Published var isNewUser : Bool
    
    private var cancellables = Set<AnyCancellable>()
    let userService: UserServiceProtocol
    
    init(userService: UserServiceProtocol) {
        self.isAuthenticated = false
        self.userService = userService
        self.isNewUser = false
        self.userInfo = VerificationModel()
        
        // Check user defaults
        let defaults = UserDefaults.standard
        self.userInfo.userId = defaults.integer(forKey: "userId") == 0 ? -1 : defaults.integer(forKey: "userId")
        self.userInfo.token = defaults.string(forKey: "token") ?? ""
        
        if (userInfo.userId != -1 && userInfo.token != "") {
            // Automatic verification
            verifyToken(token: userInfo.token, userId: userInfo.userId)
        }
    }
    
    
    func verifyToken(token: String, userId: Int) {
        let headerData = ["Authorization": "Bearer \(token)"]
        let bodyData = VerificationModel(token: token, userId: userId)
        
        userService.verify(headers: headerData, params: bodyData)
            .receive(on: RunLoop.main)
            .sink(receiveCompletion: { data in
        }, receiveValue: { data in
            if (data.isValid) {
                self.isAuthenticated = true
            } else {
                self.isAuthenticated = false
                
                // Reset user defaults
                let defaults = UserDefaults.standard
                defaults.setValue(-1, forKey: "userId")
                defaults.setValue("", forKey: "token")
            }
        }).store(in: &cancellables)
    }
    
    
    func login(email: String, password: String) {
        let bodyParams = SignInInformation(email: email, password: password)
        
        userService.login(headers: nil, params: bodyParams)
            .receive(on: RunLoop.main)
            .sink(receiveCompletion: { data in
        }, receiveValue: {[weak self] data in
            self?.userInfo = data
            
            withAnimation {
                self?.isAuthenticated = true
            }
            
            // Store in user defaults
            let defaults = UserDefaults.standard
            defaults.setValue(self?.userInfo.userId, forKey: "userId")
            defaults.setValue(self?.userInfo.token, forKey: "token")
        }).store(in: &cancellables)
    }
    
    
    func signUp(username: String, email: String, password: String, type: Int) {
        let bodyParams = SignUpInformation(username: username, email: email, password: password, type: type)
        
        userService.signUp(headers: nil, params: bodyParams)
            .receive(on: RunLoop.main)
            .sink(receiveCompletion: { data in
        }, receiveValue: {[weak self] data in
            self?.userInfo = data
            self?.isNewUser = true
            
            withAnimation {
                self?.isAuthenticated = true
            }
            
            // Store in user defaults
            let defaults = UserDefaults.standard
            defaults.setValue(self?.userInfo.userId, forKey: "userId")
            defaults.setValue(self?.userInfo.token, forKey: "token")
        }).store(in: &cancellables)
    }
}
