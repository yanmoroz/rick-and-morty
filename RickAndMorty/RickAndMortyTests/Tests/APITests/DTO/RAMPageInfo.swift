//
//  RAMPageInfo.swift
//  RickAndMortyTests
//
//  Created by Yan Moroz on 18.03.2024.
//

import Foundation

struct RAMPageInfo: Decodable {
    let count: Int
    let pages: Int
    let next: FailableURL?
    let prev: FailableURL?
}
