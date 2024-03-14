//
//  DecodableHTTPRequestMock.swift
//  RickAndMortyTests
//
//  Created by Yan Moroz on 14.03.2024.
//

import Foundation

struct DecodableHTTPRequestMock<T: Decodable>: DecodableHTTPRequest {
    typealias DecodeType = T
    
    let configuration: HTTPRequestConfiguration
}
