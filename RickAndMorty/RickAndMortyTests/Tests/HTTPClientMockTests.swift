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
    
    func test_httpClient_cancels() {
        let httpClient = HTTPClientMock()
        let exp = XCTestExpectation()
        
        URLProtocolMock.requestHandler = { request in
            (nil, nil, nil)
        }
        
        let task = httpClient.request(Locals.urlRequest) { _, _, error in
            defer { exp.fulfill() }
            
            guard let urlError = error as? URLError else {
                XCTFail("Should be URLError")
                return
            }
            
            XCTAssertEqual(urlError.code, URLError.cancelled)
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
        
        httpClient.request(Locals.urlRequest) { data, _, _ in
            defer { exp.fulfill() }
            
            guard data != nil else {
                XCTFail("Data should exists")
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
        
        httpClient.request(Locals.urlRequest) { _, _, error in
            defer { exp.fulfill() }
            
            guard error is URLError else {
                XCTFail("Should be URLError")
                return
            }
        }
        
        wait(for: exp)
    }
}
