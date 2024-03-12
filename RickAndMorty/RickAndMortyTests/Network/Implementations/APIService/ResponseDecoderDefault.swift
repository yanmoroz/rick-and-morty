//
//  ResponseDecoderDefault.swift
//  RickAndMortyTests
//
//  Created by Yan Moroz on 12.03.2024.
//

import Foundation

struct ResponseDecoderDefault: ResponseDecoder {
    let decoder = JSONDecoder()
    
    func decode<T: Decodable>(_ data: Data, toType: T.Type) -> Result<T, DecodingError> {
        do {
            let decoded = try decoder.decode(T.self, from: data)
            return .success(decoded)
        } catch {
            return .failure(error as! DecodingError)
        }
    }
}
