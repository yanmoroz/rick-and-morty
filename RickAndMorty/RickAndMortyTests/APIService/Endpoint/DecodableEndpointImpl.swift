//
//  DecodableEndpointImpl.swift
//  RickAndMortyTests
//
//  Created by Yan Moroz on 07.04.2024.
//

import Foundation

struct DecodableEndpointImpl<DecodeType>: DecodableEndpoint {
    typealias DecodeType = DecodeType
    
    var urlRequest: URLRequest
}
