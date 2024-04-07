//
//  DecodableEndpoint.swift
//  RickAndMortyTests
//
//  Created by Yan Moroz on 07.04.2024.
//

import Foundation

protocol DecodableEndpoint: Endpoint {
    associatedtype DecodeType
}
