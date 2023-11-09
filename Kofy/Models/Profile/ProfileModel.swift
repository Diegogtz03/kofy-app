//
//  ProfileModel.swift
//  Kofy
//
//  Created by Diego Gutierrez on 29/10/23.
//

import Foundation

struct ProfileInformation : Encodable {
    var username : String
    var email : String
    var password : String
    var type : Int
    
    init(username: String, email: String, password: String, type: Int) {
        self.username = username
        self.email = email
        self.password = password
        self.type = type
    }
    
    init() {
        self.username = " "
        self.email = " "
        self.password = " "
        self.type = 0
    }
}
