//
//  FailableURL.swift
//  RickAndMortyTests
//
//  Created by Yan Moroz on 18.03.2024.
//

import Foundation

struct FailableURL: Decodable {
    let url: URL?
    
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        self.url = try? container.decode(URL.self)
    }
}
