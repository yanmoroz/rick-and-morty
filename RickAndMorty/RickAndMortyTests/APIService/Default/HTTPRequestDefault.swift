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
        URLRequest(url: url)
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
