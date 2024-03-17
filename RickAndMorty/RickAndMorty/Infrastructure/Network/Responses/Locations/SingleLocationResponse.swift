//
//  SingleLocationResponse.swift
//  RickAndMortyTests
//
//  Created by Yan Moroz on 18.03.2024.
//

import Foundation

struct SingleLocationResponse: Decodable {
    let location: RAMLocation
    
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        location = try container.decode(RAMLocation.self)
    }
}
