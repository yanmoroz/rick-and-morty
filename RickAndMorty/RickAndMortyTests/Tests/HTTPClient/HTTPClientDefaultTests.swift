//
//  HTTPClientIntegrationTests.swift
//  RickAndMortyTests
//
//  Created by Yan Moroz on 14.03.2024.
//

import XCTest
@testable import RickAndMorty

final class HTTPClientDefaultTests: XCTestCase {
    enum Locals {
        static let baseAddress = "https://rickandmortyapi.com/api/"
        static let baseUrl = URL(string: baseAddress)!
        static let urlRequest = URLRequest(url: baseUrl)
        
        static let badBaseAddress = "https://rickandmortyapi-pepega.com/api/"
        static let badBaseUrl = URL(string: badBaseAddress)!
        static let badUrlRequest = URLRequest(url: badBaseUrl)
    }
}

// MARK: - Sync
extension HTTPClientDefaultTests {
    func test_httpClient_cancels() {
        let httpClient = HTTPClientDefault()
        let exp = XCTestExpectation()
        
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
        let httpClient = HTTPClientDefault()
        let exp = XCTestExpectation()
        
        httpClient.request(Locals.urlRequest) { result in
            defer { exp.fulfill() }
            
            guard case .success = result else {
                XCTFail("Should be success")
                return
            }
        }
        
        wait(for: exp)
    }
    
    func test_httpClient_returnsError() {
        let httpClient = HTTPClientDefault()
        let exp = XCTestExpectation()
        
        httpClient.request(Locals.badUrlRequest) { result in
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
extension HTTPClientDefaultTests {
    func test_httpClientAsync_returnsData() async {
        let httpClient = HTTPClientDefault()
        
        guard case .success = await httpClient.requestAsync(Locals.urlRequest) else {
            XCTFail("Should be success")
            return
        }
    }
    
    func test_httpClientAsync_returnsError() async {
        let httpClient = HTTPClientDefault()
        
        guard case .failure = await httpClient.requestAsync(Locals.badUrlRequest) else {
            XCTFail("Should be failure")
            return
        }
    }
}
