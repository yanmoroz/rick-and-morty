//
//  RickAndMortyApiRootResponse.swift
//  RickAndMortyTests
//
//  Created by Yan Moroz on 15.03.2024.
//

import Foundation

struct RickAndMortyApiRootResponse: Decodable {
    let characters: String
    let locations: String
    let episodes: String
}
