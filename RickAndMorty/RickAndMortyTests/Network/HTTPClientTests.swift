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

            guard let error else {
                XCTFail("Shouldn't be fail")
                return
            }

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
            defer {
                exp.fulfill()
            }

            guard let error else {
                XCTFail("Shouldn't be fail")
                return
            }

            XCTAssertEqual(error.code, Locals.someError.code)
        }

        wait(for: exp)
    }

    func test_httpClientMock_returnsResponse() {
        let sut = HTTPClientMock()

        URLProtocolMock.requestHandler = { request in
            (nil, Locals.response, nil)
        }

        let exp = XCTestExpectation()
        sut.request(Locals.request) { _, response, _ in
            defer {
                exp.fulfill()
            }

            guard let httpResponse = response as? HTTPURLResponse,
                  httpResponse.statusCode == Locals.badStatusCode else {
                XCTFail("Shouldn't fail")
                return
            }
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
        let baseUrl = URL(string: "https://rickandmortyapi.com/api/")!
        let apiConfiguration = APIConfigurationDefault(baseURL: baseUrl)
        
        let task = httpClient.request(request.urlRequest(using: apiConfiguration)) { data, response, urlError in
            guard let urlError else {
                XCTFail("Shouldn't be fail")
                return
            }

            XCTAssertEqual(urlError.code, Locals.cancellationError.code)
        }
        
        task.cancel()
    }
}
