//
//  HTTPResponseDecoder.swift
//  RickAndMorty
//
//  Created by Yan Moroz on 18.03.2024.
//

import Foundation

protocol HTTPResponseDecoder {
    func decode<T>(_ data: Data) -> Result<T, DecodingError> where T: Decodable
}
