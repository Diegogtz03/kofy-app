//
//  TokenVerificationModel.swift
//  Kofy
//
//  Created by Diego Gutierrez on 03/11/23.
//

import Foundation

struct TokenVerificationModel : Encodable, Decodable {
    var isValid : Bool
    
    init(isValid: Bool) {
        self.isValid = isValid
    }
    
    init() {
        self.isValid = false
    }
}
