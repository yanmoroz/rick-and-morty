//
//  HTTPClientAsyncMockTests.swift
//  RickAndMortyTests
//
//  Created by Yan Moroz on 13.03.2024.
//

import XCTest

final class HTTPClientAsyncMockTests: XCTestCase {
    
    enum Locals {
        static let baseAddress = "https://rickandmortyapi.com/api/"
        static let baseUrl = URL(string: baseAddress)!
        static let urlRequest = URLRequest(url: baseUrl)
        static let data = "foo bar baz".data(using: .utf8)
        static let response = HTTPURLResponse(url: Locals.baseUrl, statusCode: 200, httpVersion: nil, headerFields: nil)
        static let notConnectedToInternetError = URLError(URLError.notConnectedToInternet)
    }
    
    func test_httpClientAsync_returnsData() async {
        let httpClient = HTTPClientAsyncMock()
        
        URLProtocolAsyncMock.requestHandler = { request in
            (Locals.data, Locals.response)
        }
        
        let result = try? await httpClient.request(Locals.urlRequest)
        XCTAssertNotNil(result)
    }
    
    func test_httpClientAsync_returnsError() async {
        let httpClient = HTTPClientAsyncMock()
        
        URLProtocolAsyncMock.requestHandler = { request in
            throw Locals.notConnectedToInternetError
        }
        
        let result = try? await httpClient.request(Locals.urlRequest)
        XCTAssertNil(result)
    }
}
