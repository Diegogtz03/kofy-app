//
//  ProfileInformation.swift
//  Kofy
//
//  Created by Diego Gutierrez on 29/10/23.
//

import Foundation

struct ProfileInformation : Encodable, Decodable {
    var userId : Int
    var names : String
    var lastNames : String
    var birthday: String
    var gender : String
    var profilePicture: Int
    var bloodType: String
    var height: Int
    var weight: Float
    var allergies: String
    var diseases: String
    
    init(userId: Int, names: String, last_names: String, birthday: String, gender: String, profile_picture: Int, blood_type: String, height: Int, weight: Float, allergies: String, diseases: String) {
        self.userId = userId
        self.names = names
        self.lastNames = last_names
        self.birthday = birthday
        self.gender = gender
        self.profilePicture = profile_picture
        self.bloodType = blood_type
        self.height = height
        self.weight = weight
        self.allergies = allergies
        self.diseases = diseases
    }
    
    init() {
        self.userId = -1
        self.names = ""
        self.lastNames = ""
        self.birthday = ""
        self.gender = ""
        self.profilePicture = 0
        self.bloodType = ""
        self.height = 165
        self.weight = 60.0
        self.allergies = ""
        self.diseases = ""
    }
}
