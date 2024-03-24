//
//  RAMMultipleCharactersResponse.swift
//  RickAndMortyTests
//
//  Created by Yan Moroz on 24.03.2024.
//

import Foundation

struct RAMMultipleCharactersResponse: Decodable {
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
