//
//  DecodableEndpoint.swift
//  RickAndMortyTests
//
//  Created by Yan Moroz on 22.03.2024.
//

import Foundation

protocol DecodableEndpoint: Endpoint {
    associatedtype DecodeType: Decodable
    
    var decoder: JSONDecoder { get }
}
