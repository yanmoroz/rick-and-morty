//
//  PageInfo.swift
//  RickAndMortyTests
//
//  Created by Yan Moroz on 24.03.2024.
//

import Foundation

struct PageInfo: Decodable {
    let count: Int
    let pages: Int
    let next: FailableURL?
    let prev: FailableURL?
}
