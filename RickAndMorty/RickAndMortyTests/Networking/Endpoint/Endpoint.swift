//
//  Endpoint.swift
//  RickAndMortyTests
//
//  Created by Yan Moroz on 22.03.2024.
//

import Foundation

protocol Endpoint {
    associatedtype DecodeType: Decodable
    
    var baseUrl: URL { get }
    var urlRequest: URLRequest { get throws }
    var decoder: JSONDecoder { get }
    var decodeType: DecodeType.Type { get }
}
