//
//  LearnCardContent.swift
//  Kofy
//
//  Created by Diego Gutierrez on 25/10/23.
//

import Foundation

struct LearnCardContent: Encodable, Decodable, Identifiable {
    var id: Int
    var index: Int
    var content: String
    var isVideo: Bool
    var videoLink: String?
    var imageLink: String?
    
    init(id: Int, index: Int, content: String, isVideo: Bool, videoLink: String? = nil, imageLink: String? = nil) {
        self.id = id
        self.index = index
        self.content = content
        self.isVideo = isVideo
        self.videoLink = videoLink
        self.imageLink = imageLink
    }
}
