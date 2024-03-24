//
//  RAMCharactersResponse.swift
//  RickAndMortyTests
//
//  Created by Yan Moroz on 24.03.2024.
//

import Foundation

struct RAMCharactersResponse: Decodable {
    let info: PageInfo
    let results: [RAMCharacter]
}
