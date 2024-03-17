//
//  RAMLocation.swift
//  RickAndMortyTests
//
//  Created by Yan Moroz on 18.03.2024.
//

import Foundation

struct RAMLocation: Decodable {
    let id: Int
    let name: String
    let type: String
    let dimension: String
    let residents: [FailableURL]
    let url: FailableURL
    let created: String
}
