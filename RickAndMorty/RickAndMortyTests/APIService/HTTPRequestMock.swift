//
//  HTTPRequestMock.swift
//  RickAndMortyTests
//
//  Created by Yan Moroz on 14.03.2024.
//

import Foundation
@testable import RickAndMorty

class HTTPRequestMock: HTTPRequest {
    let configuration: HTTPRequestConfiguration
    
    init(configuration: HTTPRequestConfiguration) {
        self.configuration = configuration
    }
    
    var urlRequest: URLRequest {
        URLRequest(url: configuration.baseUrl)
    }
}
