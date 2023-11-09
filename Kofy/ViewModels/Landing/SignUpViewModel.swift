//
//  SignUpViewModel.swift
//  Kofy
//
//  Created by Alumno on 13/10/23.
//

import SwiftUI

class SignUpViewModel: ObservableObject {
    
    func registerSignUpData(username: String, email: String, password: String, type: Int) async throws {
        print("Entered")
        let signUpData = SignUpInformation(username: username, email: email, password: password, type: type)
        
        print("Assigned values")
        //let body: [String: Any] = ["id": id, "first_name": first_name, "last_name": last_name, "birthday": birthday, "phone_number": phone_number, "create_date": create_date, "updated_date": updated_date, "address": address]
        //  "https://flaskcontact-list-app.herokuapp.com/contacts"
        let url = URL(string: "https://kofy-back.onrender.com/user/register")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try? JSONEncoder().encode(signUpData)
        print(signUpData)
        print("Got values")
        
        let task = URLSession.shared.dataTask(with: request) {
            (data, response, error) in
            if let error = error {
                print(error)
            } else if let data = data {
                print(data)
            } else {
                print("WTF?")
            }
        }
        task.resume()
        //let results = try JSONDecoder().decode(signUpData.self, from:data)
    }
    
}
