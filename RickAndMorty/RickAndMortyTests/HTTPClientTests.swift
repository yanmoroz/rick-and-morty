//
//  HTTPClientTests.swift
//  RickAndMortyTests
//
//  Created by Yan Moroz on 10.03.2024.
//

import XCTest

final class HTTPClientTests: XCTestCase {
    
    enum Locals {
        static let baseUrl = URL(string: "https://mock.api.io")!
        static let request = URLRequest(url: baseUrl)
        static let cancellationError = URLError(URLError.cancelled)
        static let someError = URLError(URLError.notConnectedToInternet)
    }
    
    func test_httpClientMock_cancels() {
        let sut = HTTPClientMock()
        
        URLProtocolMock.requestHandler = { request in
            (nil, nil, nil)
        }
        
        let exp = XCTestExpectation()
        let task = sut.request(Locals.request) { _, _, error in
            defer { exp.fulfill() }
            let error = error as! URLError
            XCTAssertEqual(error.code, Locals.cancellationError.code)
        }
        
        task.cancel()
        wait(for: exp)
    }
    
    func test_httpClientMock_returnsError() {
        let sut = HTTPClientMock()
        
        URLProtocolMock.requestHandler = { request in
            (nil, nil, Locals.someError)
        }
        
        let exp = XCTestExpectation()
        sut.request(Locals.request) { _, _, error in
            defer { exp.fulfill() }
            let error = error as! URLError
            XCTAssertEqual(error.code, Locals.someError.code)
        }
        
        wait(for: [exp])
    }
}
