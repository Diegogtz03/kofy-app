//
//  LearnCardContent.swift
//  Kofy
//
//  Created by Diego Gutierrez on 25/10/23.
//

import Foundation

struct LearnCardContent: Encodable, Identifiable {
    var id: Int
    var lessonName: String
    var lessonIconLink: String
    var content: String
    var isVideo: Bool
    var videoLink: String?
    var imageLink: String?
    
    init(id: Int, lessonName: String, lessonIconLink: String, content: String, isVideo: Bool, videoLink: String? = nil, imageLink: String? = nil) {
        self.id = id
        self.lessonName = lessonName
        self.lessonIconLink = lessonIconLink
        self.content = content
        self.isVideo = isVideo
        self.videoLink = videoLink
        self.imageLink = imageLink
    }
}
