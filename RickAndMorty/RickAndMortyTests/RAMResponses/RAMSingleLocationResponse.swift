//
//  RAMSingleLocationResponse.swift
//  RickAndMortyTests
//
//  Created by Yan Moroz on 24.03.2024.
//

import Foundation

struct RAMSingleLocationResponse: Decodable {
    let character: RAMLocation
    
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        character = try container.decode(RAMLocation.self)
    }
}
