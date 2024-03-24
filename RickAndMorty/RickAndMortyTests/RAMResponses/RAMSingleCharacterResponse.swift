//
//  RAMSingleCharacterResponse.swift
//  RickAndMortyTests
//
//  Created by Yan Moroz on 24.03.2024.
//

import Foundation

struct RAMSingleCharacterResponse: Decodable {
    let character: RAMCharacter
    
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        character = try container.decode(RAMCharacter.self)
    }
}
