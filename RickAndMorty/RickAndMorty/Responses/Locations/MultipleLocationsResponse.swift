//
//  MultipleLocationsResponse.swift
//  RickAndMortyTests
//
//  Created by Yan Moroz on 18.03.2024.
//

import Foundation

struct MultipleLocationsResponse: Decodable {
    let info: RAMPageInfo
    let results: [RAMLocation]
    
    enum CodingKeys: CodingKey {
        case info
        case results
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.info = try container.decode(RAMPageInfo.self, forKey: .info)
        self.results = try container.decode([RAMLocation].self, forKey: .results)
    }
}
