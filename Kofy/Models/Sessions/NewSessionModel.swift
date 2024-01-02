//
//  NewSessionModel.swift
//  Kofy
//
//  Created by Diego Gutierrez on 22/11/23.
//

import Foundation

struct NewSessionModel : Encodable, Decodable, Hashable {
    var sessionName : String
    var sessionDescription : String
    var sessionDoctor : Int
    var sessionDate : String
    var color : Int
    
    init(sessionName: String, sessionDescription: String, sessionDoctor: Int, sessionDate: String, color: Int) {
        self.sessionName = sessionName
        self.sessionDescription = sessionDescription
        self.sessionDoctor = sessionDoctor
        self.sessionDate = sessionDate
        self.color = color
    }
}
