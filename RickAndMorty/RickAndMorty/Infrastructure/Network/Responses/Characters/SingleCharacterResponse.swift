//
//  SingleCharacterResponse.swift
//  RickAndMortyTests
//
//  Created by Yan Moroz on 18.03.2024.
//

import Foundation

struct SingleCharacterResponse: Decodable {
    let character: RAMCharacter
    
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        character = try container.decode(RAMCharacter.self)
    }
}
