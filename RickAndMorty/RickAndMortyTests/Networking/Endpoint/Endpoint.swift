//
//  Endpoint.swift
//  RickAndMortyTests
//
//  Created by Yan Moroz on 22.03.2024.
//

import Foundation

protocol Endpoint {
    var baseUrl: URL { get }
    var path: String? { get }
    var urlRequest: URLRequest { get throws }
}

extension Endpoint {
    var urlRequest: URLRequest {
        get throws {
            guard let components = URLComponents(string: fullPath),
                  let url = components.url
            else {
                throw EndpointError.badUrl
            }
            
            return URLRequest(url: url)
        }
    }
    
    private var fullPath: String {
        let baseUrl = baseUrl.absoluteString.trimmingCharacters(in: ["/"])
        let path = path?.trimmingCharacters(in: ["/"])
        
        guard let path else {
            return baseUrl
        }
        
        return "\(baseUrl)/\(path)"
    }
}
