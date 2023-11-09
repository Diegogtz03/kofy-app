//
//  ProfileViewModel.swift
//  Kofy
//
//  Created by Diego Gutierrez on 01/11/23.
//

import SwiftUI
import Combine

class ProfileViewModel: ObservableObject {
    @Published var profileInfo : ProfileInformation
    @Published var isNewUser : Bool
    
    private var cancellables = Set<AnyCancellable>()
    let userService: UserServiceProtocol
    
    init(userService: UserServiceProtocol) {
        self.profileInfo = ProfileInformation()
        self.isNewUser = false
        self.userService = userService
    }
    
    func getProfileInfo(popupIsShown: Binding<Bool>, token: String, userId: Int) {
        let bodyParams = VerificationModel(token: token, userId: userId)
        
        userService.getProfile(headers: ["Authorization": "Bearer \(token)"], params: bodyParams)
            .receive(on: RunLoop.main)
            .sink(receiveCompletion: { data in
                switch data {
                    case .finished:
                        break
                    case .failure:
                        print("ERROR, NEW USER")
                        popupIsShown.wrappedValue.toggle()
                        self.isNewUser = true
                }
        }, receiveValue: {[weak self] data in
            self?.profileInfo = data;
        }).store(in: &cancellables)
    }
    
    
    func setProfileInfo(bodyData: ProfileInformation, token: String, userId: Int) {
        userService.getProfile(headers: ["Authorization": "Bearer \(token)"], params: bodyData)
            .receive(on: RunLoop.main)
            .sink(receiveCompletion: { data in
                switch data {
                    case .finished:
                        break
                    case .failure:
                        print("ERROR, REGISTERING PROFILE INFO")
                }
        }, receiveValue: {[weak self] data in
            self?.profileInfo = data;
            self?.isNewUser = false;
        }).store(in: &cancellables)
    }
}
