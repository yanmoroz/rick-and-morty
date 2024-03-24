//
//  EndpointImpl.swift
//  RickAndMortyTests
//
//  Created by Yan Moroz on 22.03.2024.
//

import Foundation

struct EndpointImpl: Endpoint {
    var baseUrl: URL
    var path: String?
    var queryParameters: [String : Any]?
}
