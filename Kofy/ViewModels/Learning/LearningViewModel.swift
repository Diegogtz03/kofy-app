//
//  LearningViewModel.swift
//  Kofy
//
//  Created by Diego Gutierrez on 13/11/23.
//

import SwiftUI
import Combine

struct SelectedCard : Encodable {
    var id : Int
    var cardType : Int
    
    init(id: Int, cardType: Int) {
        self.id = id
        self.cardType = cardType
    }
    
    init() {
        self.id = -1
        self.cardType = 0
    }
}


class LearningViewModel: ObservableObject {
    @Published var cardCollections : [CardCollectionInfo]
    @Published var cardCollectionCards : [LearnCardContent]
    
    private var cancellables = Set<AnyCancellable>()
    let userService: UserServiceProtocol
    
    init(userService: UserServiceProtocol) {
        self.userService = userService
        self.cardCollections = []
        self.cardCollectionCards = []
    }
    
    func getCardCollections(token: String, userId: Int) {
        userService.getCardCollections(headers: ["Authorization": "Bearer \(token)"])
            .receive(on: RunLoop.main)
            .sink(receiveCompletion: { data in
                switch data {
                    case .finished:
                        break
                    case .failure:
                        print("ERROR, GETTING CARD COLLECTIONS")
                }
        }, receiveValue: {[weak self] data in
            self?.cardCollections = data;
        }).store(in: &cancellables)
    }
    
    func getCardCollectionCards(collectionId: Int, token: String, userId: Int, cardType: Int) {
        let bodyData = SelectedCard(id: collectionId, cardType: cardType)
        
        userService.getCardCollectionCards(headers: ["Authorization": "Bearer \(token)"], params: bodyData)
            .receive(on: RunLoop.main)
            .sink(receiveCompletion: { data in
                switch data {
                    case .finished:
                        break
                    case .failure:
                        print("ERROR, GETTING CARD COLLECTIONS CARDS")
                }
        }, receiveValue: {[weak self] data in
            self?.cardCollectionCards = data;
        }).store(in: &cancellables)
    }
}
