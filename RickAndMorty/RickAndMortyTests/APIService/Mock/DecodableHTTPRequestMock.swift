//
//  DecodableHTTPRequestMock.swift
//  RickAndMortyTests
//
//  Created by Yan Moroz on 14.03.2024.
//

import Foundation

class DecodableHTTPRequestMock<T: Decodable>: HTTPRequestMock, DecodableHTTPRequest {
    typealias DecodeType = T
}
