//
//  RAMMultipleEpisodesResponse.swift
//  RickAndMortyTests
//
//  Created by Yan Moroz on 24.03.2024.
//

import Foundation

struct RAMMultipleEpisodesResponse: Decodable {
    let episodes: [RAMEpisode]
    
    init(from decoder: Decoder) throws {
        var container = try decoder.unkeyedContainer()
        var episodes: [RAMEpisode] = []
        
        while !container.isAtEnd {
            let episode = try container.decode(RAMEpisode.self)
            episodes.append(episode)
        }
        
        self.episodes = episodes
    }
}
