//
//  ResourcesResponse.swift
//  RickAndMortyTests
//
//  Created by Yan Moroz on 05.04.2024.
//

import Foundation

struct ResourcesResponse: Decodable {
    let episodes: URL
    let locations: URL
    let characters: URL
}
