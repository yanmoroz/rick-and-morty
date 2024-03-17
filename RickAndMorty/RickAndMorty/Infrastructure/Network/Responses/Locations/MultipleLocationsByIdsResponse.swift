//
//  MultipleLocationsByIdsResponse.swift
//  RickAndMortyTests
//
//  Created by Yan Moroz on 18.03.2024.
//

import Foundation

struct MultipleLocationsByIdsResponse: Decodable {
    let locations: [RAMLocation]
    
    init(from decoder: Decoder) throws {
        var container = try decoder.unkeyedContainer()
        var locations: [RAMLocation] = []
        
        while !container.isAtEnd {
            let location = try container.decode(RAMLocation.self)
            locations.append(location)
        }
        
        self.locations = locations
    }
}
