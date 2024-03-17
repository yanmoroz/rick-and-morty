//
//  HTTPRequestDefault.swift
//  RickAndMortyTests
//
//  Created by Yan Moroz on 15.03.2024.
//

import Foundation

class HTTPRequestDefault: HTTPRequest {
    var configuration: HTTPRequestConfiguration
    
    init(configuration: HTTPRequestConfiguration) {
        self.configuration = configuration
    }
    
    var urlRequest: URLRequest {
        let url = url
        
        guard let queryParameters = configuration.queryParameters else {
            return URLRequest(url: url)
        }
        
        guard var urlComponents = URLComponents(string: url.absoluteString) else {
            return URLRequest(url: url)
        }
        
        urlComponents.queryItems = queryParameters.map { URLQueryItem(name: $0.key, value: "\($0.value)") }
        return URLRequest(url: urlComponents.url!)
    }
    
    private var url: URL {
        guard let path = configuration.path else {
            return configuration.baseUrl
        }
        
        return configuration.baseUrl
            .appending(path: path)
            .singleDashed
    }
}
