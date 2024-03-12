//
//  RickAndMortyAPIRoot.swift
//  RickAndMortyTests
//
//  Created by Yan Moroz on 13.03.2024.
//

import Foundation

struct RickAndMortyAPIRoot: Decodable {
    let characters: URL
    let locations: URL
    let episodes: URL
}
