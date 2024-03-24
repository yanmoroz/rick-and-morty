//
//  RAMResourcesResponse.swift
//  RickAndMortyTests
//
//  Created by Yan Moroz on 24.03.2024.
//

import Foundation

struct RAMResourcesResponse: Decodable {
    let characters: URL
    let locations: URL
    let episodes: URL
}
