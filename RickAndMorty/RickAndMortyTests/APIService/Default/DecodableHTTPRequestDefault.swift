//
//  DecodableHTTPRequestDefault.swift
//  RickAndMortyTests
//
//  Created by Yan Moroz on 15.03.2024.
//

import Foundation

class DecodableHTTPRequestDefault<T: Decodable>: HTTPRequestDefault, DecodableHTTPRequest {
    typealias DecodeType = T
}
