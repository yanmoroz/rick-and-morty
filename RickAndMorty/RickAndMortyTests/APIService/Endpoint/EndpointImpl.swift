//
//  EndpointImpl.swift
//  RickAndMortyTests
//
//  Created by Yan Moroz on 05.04.2024.
//

import Foundation

struct EndpointImpl<DecodeType>: Endpoint {
    typealias DecodeType = DecodeType
    
    var urlRequest: URLRequest
}
