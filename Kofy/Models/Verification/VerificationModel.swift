//
//  VerificationModel.swift
//  Kofy
//
//  Created by Diego Gutierrez on 30/10/23.
//

import Foundation

struct VerificationModel : Encodable, Decodable {
    var token : String
    var userId : Int
    
    init(token: String, userId: Int) {
        self.token = token
        self.userId = userId
        
        // Store values in user defaults when logging in
        let defaults = UserDefaults.standard
        defaults.setValue(token, forKey: "token")
        defaults.setValue(userId, forKey: "userId")
    }
    
    init() {
        self.token = ""
        self.userId = -1
    }
}
