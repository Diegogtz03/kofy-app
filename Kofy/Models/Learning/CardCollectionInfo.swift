//
//  CardCollectionInfo.swift
//  Kofy
//
//  Created by Diego Gutierrez on 13/11/23.
//

import Foundation

struct CardCollectionInfo: Encodable, Decodable, Identifiable {
    var id: Int
    var name: String
    var icon: String
    
    init(id: Int, name: String, icon: String) {
        self.id = id
        self.name = name
        self.icon = icon
    }
}
