//
//  HTTPClientAsyncMock.swift
//  RickAndMortyTests
//
//  Created by Yan Moroz on 13.03.2024.
//

import Foundation

class HTTPClientAsyncMock: HTTPClientAsync {
    lazy var urlSession: URLSession = {
        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [URLProtocolAsyncMock.self]
        return URLSession(configuration: configuration)
    }()
    
    func request(_ urlRequest: URLRequest) async throws -> (Data, URLResponse) {
        try await urlSession.data(for: urlRequest)
    }
}
