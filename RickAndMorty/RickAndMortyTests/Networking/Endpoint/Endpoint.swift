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
    var queryParameters: [String: Any]? { get }
    var urlRequest: URLRequest { get throws }
}

extension Endpoint {
    var urlRequest: URLRequest {
        get throws {
            guard var components = URLComponents(string: fullPath) else {
                throw EndpointError.badUrl
            }
            
            components.queryItems = queryParameters?.map { URLQueryItem(name: $0.key, value: "\($0.value)") }
            
            guard let url = components.url else {
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
