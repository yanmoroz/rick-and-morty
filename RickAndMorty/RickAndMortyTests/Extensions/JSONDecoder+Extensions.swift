//
//  JSONDecoder+Extensions.swift
//  RickAndMortyTests
//
//  Created by Yan Moroz on 10.04.2024.
//

import Foundation

extension JSONDecoder {
    static let ramJsonDecoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .formatted(.ramDateFormatter)
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return decoder
    }()
}
