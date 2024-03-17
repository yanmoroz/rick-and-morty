//
//  RAMEpisode.swift
//  RickAndMortyTests
//
//  Created by Yan Moroz on 18.03.2024.
//

import Foundation

struct RAMEpisode: Decodable {
    let id: Int
    let name: String
    let airDate: String
    let episode: String
    let characters: [FailableURL]
    let url: FailableURL
    let created: String
}
