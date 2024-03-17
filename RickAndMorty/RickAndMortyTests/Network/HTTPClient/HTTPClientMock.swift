//
//  HTTPClientMock.swift
//  RickAndMortyTests
//
//  Created by Yan Moroz on 13.03.2024.
//

import Foundation
@testable import RickAndMorty

class HTTPClientMock: HTTPClient {
    lazy var urlSession: URLSession = {
        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [URLProtocolMock.self]
        return URLSession(configuration: configuration)
    }()
    
    lazy var urlSessionAsync: URLSession = {
        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [URLProtocolAsyncMock.self]
        return URLSession(configuration: configuration)
    }()
}
