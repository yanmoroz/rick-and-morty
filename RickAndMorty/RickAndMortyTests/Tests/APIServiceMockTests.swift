//
//  APIServiceMockTests.swift
//  RickAndMortyTests
//
//  Created by Yan Moroz on 13.03.2024.
//

import XCTest

final class APIServiceMockTests: XCTestCase {
    
    enum Locals {
        static let baseAddress = "https://rickandmortyapi.com/api/"
//        static let baseUrl = URL(string: baseAddress)!
//        static let urlRequest = URLRequest(url: baseUrl)
//        static let data = "foo bar baz".data(using: .utf8)
//        static let response = HTTPURLResponse(url: Locals.baseUrl, statusCode: 200, httpVersion: nil, headerFields: nil)
//        static let notConnectedToInternetError = URLError(URLError.notConnectedToInternet)
        static let cancelledError = URLError(URLError.cancelled)
    }
    
    func test_apiService_decodableRequest_cancels() {
        let apiService = APIServiceMock(httpClient: HTTPClientMock())
        let configuration = HTTPRequestConfigurationMock(baseUrl: Locals.baseAddress)
        let httpRequest = DecodableHTTPRequestMock<DecodableMock>(configuration: configuration)
        let exp = XCTestExpectation()
        
        let task = apiService.request(httpRequest) { result in
            defer { exp.fulfill() }
            
            guard case let .failure(apiServiceError) = result,
                  case let .urlError(urlError) = apiServiceError,
                  urlError.code == Locals.cancelledError.code else {
                XCTFail("Should be .cancelled")
                return
            }
        }
        
        task?.cancel()
        wait(for: exp)
    }
    
    func test_apiService_request_cancels() {
        let apiService = APIServiceMock(httpClient: HTTPClientMock())
        let configuration = HTTPRequestConfigurationMock(baseUrl: Locals.baseAddress)
        let httpRequest = HTTPRequestMock(configuration: configuration)
        let exp = XCTestExpectation()
        
        let task = apiService.request(httpRequest) { apiServiceError in
            defer { exp.fulfill() }
            
            guard let apiServiceError,
                  case let .urlError(urlError) = apiServiceError,
                  urlError.code == Locals.cancelledError.code else {
                XCTFail("Should be .cancelled")
                return
            }
        }
        
        task?.cancel()
        wait(for: exp)
    }
}

extension HTTPRequest {
    func urlRequest() -> URLRequest? {
        guard let url = URL(string: configuration.baseUrl) else {
            return nil
        }
        
        return URLRequest(url: url)
    }
}

struct HTTPRequestMock: HTTPRequest {
    let configuration: HTTPRequestConfiguration
}

struct DecodableHTTPRequestMock<T: Decodable>: DecodableHTTPRequest {
    typealias DecodeType = T
    
    let configuration: HTTPRequestConfiguration
}

struct HTTPRequestConfigurationMock: HTTPRequestConfiguration {
    let baseUrl: String
}

struct DecodableMock: Decodable {
    
}
