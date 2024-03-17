//
//  RAMCharacter.swift
//  RickAndMortyTests
//
//  Created by Yan Moroz on 18.03.2024.
//

import Foundation

struct RAMCharacter: Decodable {
    let id: Int
    let name: String
    let status: String
    let species: String
    let type: String
    let gender: String
    let origin: RAMOrigin
    let location: RAMLocation
    let image: FailableURL
    let episode: [FailableURL]
    let url: FailableURL
    let created: String
    
    struct RAMOrigin: Decodable {
        let name: String
        let url: FailableURL
    }

    struct RAMLocation: Decodable {
        let name: String
        let url: FailableURL
    }
}
