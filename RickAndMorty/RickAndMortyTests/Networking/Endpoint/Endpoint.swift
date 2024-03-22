//
//  Endpoint.swift
//  RickAndMortyTests
//
//  Created by Yan Moroz on 22.03.2024.
//

import Foundation

protocol Endpoint {
    var baseUrl: URL { get }
    var urlRequest: URLRequest { get throws }
}

extension Endpoint {
    var urlRequest: URLRequest {
        get throws {
            guard let components = URLComponents(string: baseUrl.absoluteString),
                  let url = components.url
            else {
                throw EndpointError.badUrl
            }
            
            return URLRequest(url: url)
        }
    }
}
