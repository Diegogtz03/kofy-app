//
//  DoctorInfo.swift
//  Kofy
//
//  Created by Diego Gutierrez on 29/10/23.
//

import Foundation

struct DoctorInfo : Encodable, Identifiable {
    var id : Int
    var doctorName : String
    var doctorFocus : String
    var doctorPhone : String
    var doctorEmail : String
    
    init(id: Int, doctorName: String, doctorFocus: String, doctorPhone: String, doctorEmail: String) {
        self.id = id
        self.doctorName = doctorName
        self.doctorFocus = doctorFocus
        self.doctorPhone = doctorPhone
        self.doctorEmail = doctorEmail
    }
    
    init() {
        self.id = 0
        self.doctorName = "Oscar Gutierrez"
        self.doctorFocus = "Ortodoncista"
        self.doctorPhone = "899-912-3124"
        self.doctorEmail = "drOscar@gmail.com"
    }
}
