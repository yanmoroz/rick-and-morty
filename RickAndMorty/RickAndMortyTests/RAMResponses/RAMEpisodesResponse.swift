//
//  RAMEpisodesResponse.swift
//  RickAndMortyTests
//
//  Created by Yan Moroz on 24.03.2024.
//

import Foundation

struct RAMEpisodesResponse: Decodable {
    let info: PageInfo
    let results: [RAMEpisode]
}
