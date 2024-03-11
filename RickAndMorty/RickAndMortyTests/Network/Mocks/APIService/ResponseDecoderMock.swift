//
//  ResponseDecoderMock.swift
//  RickAndMortyTests
//
//  Created by Yan Moroz on 11.03.2024.
//

import Foundation

struct ResponseDecoderMock: ResponseDecoder {
    func decode<T: Decodable>(_ data: Data, toType: T.Type) throws -> T {
        try JSONDecoder().decode(T.self, from: data)
    }
}
