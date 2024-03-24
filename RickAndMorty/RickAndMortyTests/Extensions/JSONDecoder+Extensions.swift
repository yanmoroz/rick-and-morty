//
//  JSONDecoder+Extensions.swift
//  RickAndMortyTests
//
//  Created by Yan Moroz on 24.03.2024.
//

import Foundation

extension JSONDecoder {
    static let ramJsonDecoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .formatted(.ramDateFormatter)
        return decoder
    }()
}
