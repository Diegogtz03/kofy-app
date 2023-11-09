//
//  SignInViewModel.swift
//  Kofy
//
//  Created by Diego Gutierrez on 17/10/23.
//

import Combine
import SwiftUI

class SignInViewModel: ObservableObject {
    private var cancellables = Set<AnyCancellable>()
    let userService: UserServiceProtocol
    
    init(userService: UserServiceProtocol) {
        self.userService = userService
    }
    
//    func signIn(email: String, password: String) {
//        let bodyParams = ["email": email, "password": password]
//        
//        userService.login(headers: nil, params: bodyParams)
//            .receive(on: RunLoop.main)
//            .sink(receiveCompletion: { data in
//            
//        }, receiveValue: {[weak self] data in
//            self?.users = data
//        }).store(in: &cancellables)
//    }
    
    
    func verifySignIn(email: String, password: String) async throws {
        let signInData = SignInInformation(email: email, password: password)
        
        let url = URL(string: "https://kofy-back.onrender.com/user/login")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try? JSONEncoder().encode(signInData)
        
        let task = URLSession.shared.dataTask(with: request) {
            (data, response, error) in
            if let error = error {
                print(error)
            } else if let data = data {
                if let json = try? JSONSerialization.jsonObject(with: data) {
                    print(json)
                }
            } else {
                print("WTF?")
            }
        }
        task.resume()
        
    }
}
