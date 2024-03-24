//
//  RAMLocationSlim.swift
//  RickAndMortyTests
//
//  Created by Yan Moroz on 24.03.2024.
//

import Foundation

struct RAMLocationSlim: Decodable {
    let name: String
    let url: FailableURL
}
