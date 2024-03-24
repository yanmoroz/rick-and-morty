//
//  RAMSingleEpisodeResponse.swift
//  RickAndMortyTests
//
//  Created by Yan Moroz on 24.03.2024.
//

import Foundation

struct RAMSingleEpisodeResponse: Decodable {
    let character: RAMEpisode
    
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        character = try container.decode(RAMEpisode.self)
    }
}
