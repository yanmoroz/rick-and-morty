//
//  Endpoint.swift
//  RickAndMortyTests
//
//  Created by Yan Moroz on 05.04.2024.
//

import Foundation

protocol Endpoint {
    associatedtype DecodeType
    
    var urlRequest: URLRequest { get }
}
