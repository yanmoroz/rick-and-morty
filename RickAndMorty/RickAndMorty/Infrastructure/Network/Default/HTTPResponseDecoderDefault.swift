//
//  HTTPResponseDecoderDefault.swift
//  RickAndMortyTests
//
//  Created by Yan Moroz on 15.03.2024.
//

import Foundation

struct HTTPResponseDecoderDefault: HTTPResponseDecoder {
    let decoder = {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return decoder
    }()
    
    func decode<T>(_ data: Data) -> Result<T, DecodingError> where T: Decodable {
        do {
            let decoded = try decoder.decode(T.self, from: data)
            return .success(decoded)
        } catch {
            return .failure(error as! DecodingError)
        }
    }
}
