//
//  SingleEpisodeResponse.swift
//  RickAndMortyTests
//
//  Created by Yan Moroz on 18.03.2024.
//

import Foundation

struct SingleEpisodeResponse: Decodable {
    let episode: RAMEpisode
    
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        episode = try container.decode(RAMEpisode.self)
    }
}
