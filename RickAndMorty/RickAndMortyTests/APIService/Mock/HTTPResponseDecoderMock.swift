//
//  HTTPResponseDecoderMock.swift
//  RickAndMortyTests
//
//  Created by Yan Moroz on 14.03.2024.
//

import Foundation

struct HTTPResponseDecoderMock: HTTPResponseDecoder {
    func decode<T>(_ data: Data) -> Result<T, DecodingError> where T: Decodable {
        let decoder = JSONDecoder()
        do {
            let decoded = try decoder.decode(T.self, from: data)
            return .success(decoded)
        } catch {
            return .failure(error as! DecodingError)
        }
    }
}
