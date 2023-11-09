//
//  LearnCardsViewModel.swift
//  Kofy
//
//  Created by Diego Gutierrez on 25/10/23.
//

import Foundation

class LearnCardsViewModel : ObservableObject {
    @Published var cards = [LearnCardContent]()
    
    init() {
        loadCards()
   }
    
    func loadCards() {
        self.cards.append(LearnCardContent(id: 1, lessonName: "Inhalador", lessonIconLink: "learn1", content: "Agitar el inhalador", isVideo: false, imageLink: "inhalador-01"))
        self.cards.append(LearnCardContent(id: 2, lessonName: "Inhalador", lessonIconLink: "learn1", content: "Colocar inhalador en la boca", isVideo: false, imageLink: "inhalador-01"))
        self.cards.append(LearnCardContent(id: 3, lessonName: "Inhalador", lessonIconLink: "learn1", content: "Respirar profundamente mientras se acciona el inhalador", isVideo: false, imageLink: "inhalador-01"))
        self.cards.append(LearnCardContent(id: 4, lessonName: "Inhalador", lessonIconLink: "learn1", content: "Sostener la respiración por lo menos 10 segundos", isVideo: false, imageLink: "inhalador-01"))
        self.cards.append(LearnCardContent(id: 5, lessonName: "Inhalador", lessonIconLink: "learn1", content: "Observe el siguiente video", isVideo: true, videoLink: "https://www.youtube.com/watch?v=6xQl6bfppvg"))
    }
}
