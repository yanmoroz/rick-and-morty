//
//  MultipleCharactersByIdsResponse.swift
//  RickAndMortyTests
//
//  Created by Yan Moroz on 18.03.2024.
//

import Foundation

struct MultipleCharactersByIdsResponse: Decodable {
    let characters: [RAMCharacter]
    
    init(from decoder: Decoder) throws {
        var container = try decoder.unkeyedContainer()
        var characters: [RAMCharacter] = []
        
        while !container.isAtEnd {
            let character = try container.decode(RAMCharacter.self)
            characters.append(character)
        }
        
        self.characters = characters
    }
}
