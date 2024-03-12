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
        static let badStatusCode = 404
        static let response = HTTPURLResponse(url: baseUrl, statusCode: badStatusCode)
        static let data = "foo bar".data(using: .utf8)
    }

    func test_httpClientMock_cancels() {
        let sut = HTTPClientMock()

        URLProtocolMock.requestHandler = { request in
            (nil, nil, nil)
        }

        let exp = XCTestExpectation()
        let task = sut.request(Locals.request) { _, _, error in
            defer {
                exp.fulfill()
            }
            
            XCTAssertEqual(error?.code, Locals.cancellationError.code)
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
            defer {
                exp.fulfill()
            }
            
            XCTAssertEqual(error?.code, Locals.someError.code)
        }

        wait(for: exp)
    }

    func test_httpClientMock_returnsHTTPResponse() {
        let sut = HTTPClientMock()

        URLProtocolMock.requestHandler = { request in
            (nil, Locals.response, nil)
        }

        let exp = XCTestExpectation()
        sut.request(Locals.request) { _, response, _ in
            defer {
                exp.fulfill()
            }
            
            XCTAssertNotNil(response as? HTTPURLResponse)
        }

        wait(for: exp)
    }

    func test_httpClientMock_returnsData() {
        let sut = HTTPClientMock()

        URLProtocolMock.requestHandler = { request in
            (Locals.data, nil, nil)
        }

        let exp = XCTestExpectation()
        sut.request(Locals.request) { data, _, _ in
            defer {
                exp.fulfill()
            }

            XCTAssertEqual(data, Locals.data)
        }

        wait(for: exp)
    }
}

extension HTTPClientTests {
    func test_httpClientDefault_cancels() {
        let httpClient = HTTPClientDefault()
        let request = APIRequestDefault()
        let apiConfiguration = makeAPIConfiguration()
        let exp = XCTestExpectation()
        
        let task = httpClient.request(request.urlRequest(using: apiConfiguration)) { _, _, urlError in
            defer {
                exp.fulfill()
            }

            XCTAssertEqual(urlError?.code, Locals.cancellationError.code)
        }
        
        task.cancel()
        wait(for: exp)
    }
    
    func test_httpClientDefault_returnsError() {
        let urlSessionConfiguration = URLSessionConfiguration.default
        urlSessionConfiguration.timeoutIntervalForRequest = 0.01
        
        let httpClient = HTTPClientDefault(urlSessionConfiguration: urlSessionConfiguration)
        let request = APIRequestDefault()
        let apiConfiguration = makeAPIConfiguration()
        let exp = XCTestExpectation()
        
        httpClient.request(request.urlRequest(using: apiConfiguration)) { _, _, urlError in
            defer {
                exp.fulfill()
            }
            
            XCTAssertEqual(urlError?.code, URLError.timedOut)
        }
        
        wait(for: exp)
    }
    
    func test_httpClientDefault_returnsHTTPResponse() {
        let httpClient = HTTPClientDefault()
        let request = APIRequestDefault()
        let apiConfiguration = makeAPIConfiguration()
        let exp = XCTestExpectation()
        
        httpClient.request(request.urlRequest(using: apiConfiguration)) { _, response, _ in
            defer {
                exp.fulfill()
            }
            
            XCTAssertNotNil(response as? HTTPURLResponse)
        }
        
        wait(for: exp)
    }
    
    func test_httpClientDefault_returnsData() {
        let httpClient = HTTPClientDefault()
        let request = APIRequestDefault()
        let apiConfiguration = makeAPIConfiguration()
        let exp = XCTestExpectation()
        
        httpClient.request(request.urlRequest(using: apiConfiguration)) { data, _, _ in
            defer {
                exp.fulfill()
            }
            
            XCTAssertNotNil(data)
        }
        
        wait(for: exp)
    }
    
    private func makeAPIConfiguration() -> APIConfiguration {
        let baseUrl = URL(string: "https://rickandmortyapi.com/api/")!
        return APIConfigurationDefault(baseURL: baseUrl)
    }
}
