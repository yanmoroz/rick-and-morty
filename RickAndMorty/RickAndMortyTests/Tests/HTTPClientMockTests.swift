//
//  HTTPClientMockTests.swift
//  RickAndMortyTests
//
//  Created by Yan Moroz on 13.03.2024.
//

import XCTest

final class HTTPClientMockTests: XCTestCase {
    enum Locals {
        static let baseAddress = "https://rickandmortyapi.com/api/"
        static let baseUrl = URL(string: baseAddress)!
        static let urlRequest = URLRequest(url: baseUrl)
        static let data = "foo bar baz".data(using: .utf8)
        static let response = HTTPURLResponse(url: Locals.baseUrl, statusCode: 200, httpVersion: nil, headerFields: nil)
        static let notConnectedToInternetError = URLError(URLError.notConnectedToInternet)
    }
}

// MARK: - Sync
extension HTTPClientMockTests {
    func test_httpClient_cancels() {
        let httpClient = HTTPClientMock()
        let exp = XCTestExpectation()
        
        URLProtocolMock.requestHandler = { request in
            (nil, nil, nil)
        }
        
        let task = httpClient.request(Locals.urlRequest) { result in
            defer { exp.fulfill() }
            
            if case let .failure(urlError) = result {
                XCTAssertEqual(urlError.code, URLError.cancelled)
            }
        }
        
        task.cancel()
        wait(for: exp)
    }
    
    func test_httpClient_returnsData() {
        let httpClient = HTTPClientMock()
        let exp = XCTestExpectation()
        
        URLProtocolMock.requestHandler = { request in
            (Locals.data, Locals.response, nil)
        }
        
        httpClient.request(Locals.urlRequest) { result in
            defer { exp.fulfill() }
            
            guard case .success = result else {
                XCTFail("Should be URLError")
                return
            }
        }
        
        wait(for: exp)
    }
    
    func test_httpClient_returnsError() {
        let httpClient = HTTPClientMock()
        let exp = XCTestExpectation()
        
        URLProtocolMock.requestHandler = { request in
            (nil, nil, Locals.notConnectedToInternetError)
        }
        
        httpClient.request(Locals.urlRequest) { result in
            defer { exp.fulfill() }
            
            guard case .failure = result else {
                XCTFail("Should be failure")
                return
            }
        }
        
        wait(for: exp)
    }
}

// MARK: - Async
extension HTTPClientMockTests {
    func test_httpClientAsync_returnsData() async {
        let httpClient = HTTPClientMock()
        
        URLProtocolAsyncMock.requestHandler = { request in
            (Locals.data, Locals.response)
        }
        
        guard case .success = await httpClient.requestAsync(Locals.urlRequest) else {
            XCTFail("Should be success")
            return
        }
    }
    
    func test_httpClientAsync_returnsError() async {
        let httpClient = HTTPClientMock()
        
        URLProtocolAsyncMock.requestHandler = { request in
            throw Locals.notConnectedToInternetError
        }
        
        guard case .failure = await httpClient.requestAsync(Locals.urlRequest) else {
            XCTFail("Should be failure")
            return
        }
    }
}
