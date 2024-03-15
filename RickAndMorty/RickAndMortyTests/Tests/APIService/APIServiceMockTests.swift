//
//  APIServiceMockTests.swift
//  RickAndMortyTests
//
//  Created by Yan Moroz on 13.03.2024.
//

import XCTest

final class APIServiceMockTests: XCTestCase {
    enum Locals {
        private static let baseAddress = "https://rickandmortyapi.com/"
        static let baseUrl = URL(string: baseAddress)!
        static let data = #"{"id": 13}"#.data(using: .utf8)
        static let junkData = "foo bar baz".data(using: .utf8)
        static let goodResponse = HTTPURLResponse(url: Locals.baseUrl, statusCode: 200, httpVersion: nil, headerFields: nil)
        static let badResponse = HTTPURLResponse(url: Locals.baseUrl, statusCode: 404, httpVersion: nil, headerFields: nil)
        static let cancelledError = URLError(URLError.cancelled)
        static let notConnectedToInternetError = URLError(URLError.notConnectedToInternet)
    }
    
    func makeSUT() -> APIService {
        APIServiceMock(
            httpClient: HTTPClientMock(),
            responseValidator: HTTPURLResponseValidatorMock(),
            responseDecoder: HTTPResponseDecoderMock()
        )
    }
}

// MARK: - Sync
extension APIServiceMockTests {
    func test_apiService_request_cancels() {
        let apiService = makeSUT()
        let configuration = HTTPRequestConfigurationMock(baseUrl: Locals.baseUrl)
        let httpRequest = HTTPRequestMock(configuration: configuration)
        let exp = XCTestExpectation()
        
        URLProtocolMock.requestHandler = { request in
            (nil, nil, nil)
        }
        
        let task = apiService.request(httpRequest) { apiServiceError in
            defer { exp.fulfill() }
            
            guard let apiServiceError,
                  case let .urlError(urlError) = apiServiceError
            else {
                XCTFail("Should be .urlError")
                return
            }
            
            XCTAssertEqual(urlError.code, Locals.cancelledError.code)
        }
        
        task.cancel()
        wait(for: exp)
    }
    
    func test_apiService_decodableRequest_cancels() {
        let apiService = makeSUT()
        let configuration = HTTPRequestConfigurationMock(baseUrl: Locals.baseUrl)
        let httpRequest = HTTPRequestDecodableMock<DecodableMock>(configuration: configuration)
        let exp = XCTestExpectation()
        
        URLProtocolMock.requestHandler = { request in
            (nil, nil, nil)
        }
        
        let task = apiService.requestDecodable(httpRequest) { result in
            defer { exp.fulfill() }
            
            guard case let .failure(apiServiceError) = result,
                  case let .urlError(urlError) = apiServiceError
            else {
                XCTFail("Should be .urlError")
                return
            }
            
            XCTAssertEqual(urlError.code, Locals.cancelledError.code)
        }
        
        task.cancel()
        wait(for: exp)
    }
    
    func test_apiService_request_returnsNilErrorOnSuccess() {
        let apiService = makeSUT()
        let configuration = HTTPRequestConfigurationMock(baseUrl: Locals.baseUrl)
        let httpRequest = HTTPRequestMock(configuration: configuration)
        let exp = XCTestExpectation()
        
        URLProtocolMock.requestHandler = { request in
            (nil, Locals.goodResponse, nil)
        }
        
        apiService.request(httpRequest) { apiServiceError in
            defer { exp.fulfill() }
            
            XCTAssertNil(apiServiceError)
        }
        
        wait(for: exp)
    }
    
    func test_apiService_decodableRequest_returnsSmthOnSuccess() {
        let apiService = makeSUT()
        let configuration = HTTPRequestConfigurationMock(baseUrl: Locals.baseUrl)
        let httpRequest = HTTPRequestDecodableMock<DecodableMock>(configuration: configuration)
        let exp = XCTestExpectation()
        
        URLProtocolMock.requestHandler = { request in
            (Locals.data, Locals.goodResponse, nil)
        }
        
        apiService.requestDecodable(httpRequest) { result in
            defer { exp.fulfill() }
            
            guard case .success = result else {
                XCTFail("Should be .success")
                return
            }
        }
        
        wait(for: exp)
    }
    
    func test_apiService_request_returnsUrlError() {
        let apiService = makeSUT()
        let configuration = HTTPRequestConfigurationMock(baseUrl: Locals.baseUrl)
        let httpRequest = HTTPRequestMock(configuration: configuration)
        let exp = XCTestExpectation()
        
        URLProtocolMock.requestHandler = { request in
            (nil, nil, Locals.notConnectedToInternetError)
        }
        
        apiService.request(httpRequest) { apiServiceError in
            defer { exp.fulfill() }
            
            guard let apiServiceError,
                  case .urlError = apiServiceError
            else {
                XCTFail("Should be .urlError")
                return
            }
        }
        
        wait(for: exp)
    }
    
    func test_apiService_request_returnsBadStatusCodeError() {
        let apiService = makeSUT()
        let configuration = HTTPRequestConfigurationMock(baseUrl: Locals.baseUrl)
        let httpRequest = HTTPRequestMock(configuration: configuration)
        let exp = XCTestExpectation()
        
        URLProtocolMock.requestHandler = { request in
            (nil, Locals.badResponse, nil)
        }
        
        apiService.request(httpRequest) { apiServiceError in
            defer { exp.fulfill() }
            
            guard let apiServiceError,
                  case .badStatusCode = apiServiceError
            else {
                XCTFail("Should be .badStatusCode")
                return
            }
        }
        
        wait(for: exp)
    }
    
    func test_apiService_decodableRequest_returnsUrlError() {
        let apiService = makeSUT()
        let configuration = HTTPRequestConfigurationMock(baseUrl: Locals.baseUrl)
        let httpRequest = HTTPRequestDecodableMock<DecodableMock>(configuration: configuration)
        let exp = XCTestExpectation()
        
        URLProtocolMock.requestHandler = { request in
            (nil, nil, Locals.notConnectedToInternetError)
        }
        
        apiService.requestDecodable(httpRequest) { result in
            defer { exp.fulfill() }
            
            guard case let .failure(apiServiceError) = result,
                  case .urlError = apiServiceError
            else {
                XCTFail("Should be .urlError")
                return
            }
        }
        
        wait(for: exp)
    }
    
    func test_apiService_decodableRequest_returnsBadStatusCodeError() {
        let apiService = makeSUT()
        let configuration = HTTPRequestConfigurationMock(baseUrl: Locals.baseUrl)
        let httpRequest = HTTPRequestDecodableMock<DecodableMock>(configuration: configuration)
        let exp = XCTestExpectation()
        
        URLProtocolMock.requestHandler = { request in
            (nil, Locals.badResponse, nil)
        }
        
        apiService.requestDecodable(httpRequest) { result in
            defer { exp.fulfill() }
            
            guard case let .failure(apiServiceError) = result,
                  case .badStatusCode = apiServiceError
            else {
                XCTFail("Should be .badStatusCode")
                return
            }
        }
        
        wait(for: exp)
    }
    
    func test_apiService_decodableRequest_returnsDecodingError() {
        let apiService = makeSUT()
        let configuration = HTTPRequestConfigurationMock(baseUrl: Locals.baseUrl)
        let httpRequest = HTTPRequestDecodableMock<DecodableMock>(configuration: configuration)
        let exp = XCTestExpectation()
        
        URLProtocolMock.requestHandler = { request in
            (Locals.junkData, Locals.goodResponse, nil)
        }
        
        apiService.requestDecodable(httpRequest) { result in
            defer { exp.fulfill() }
            
            guard case let .failure(apiServiceError) = result,
                  case .decodingError = apiServiceError
            else {
                XCTFail("Should be .decodingError")
                return
            }
        }
        
        wait(for: exp)
    }
}

// MARK: - Async
extension APIServiceMockTests {
    func test_apiService_request_async_returnsNilErrorOnSuccess() async {
        let apiService = makeSUT()
        let configuration = HTTPRequestConfigurationMock(baseUrl: Locals.baseUrl)
        let httpRequest = HTTPRequestMock(configuration: configuration)
        
        URLProtocolAsyncMock.requestHandler = { request in
            (Locals.data, Locals.goodResponse)
        }
        
        guard await apiService.requestAsync(httpRequest) == nil else {
            XCTFail("Should be nil")
            return
        }
    }
    
    func test_apiService_decodableRequest_async_returnsSmthOnSuccess() async {
        let apiService = makeSUT()
        let configuration = HTTPRequestConfigurationMock(baseUrl: Locals.baseUrl)
        let httpRequest = HTTPRequestDecodableMock<DecodableMock>(configuration: configuration)
        
        URLProtocolAsyncMock.requestHandler = { request in
            (Locals.data, Locals.goodResponse)
        }
        
        guard case .success = await apiService.requestDecodableAsync(httpRequest) else {
            XCTFail("Should be success")
            return
        }
    }
    
    func test_apiService_request_async_returnsUrlError() async {
        let apiService = makeSUT()
        let configuration = HTTPRequestConfigurationMock(baseUrl: Locals.baseUrl)
        let httpRequest = HTTPRequestMock(configuration: configuration)
        
        URLProtocolAsyncMock.requestHandler = { request in
            throw Locals.notConnectedToInternetError
        }
        
        guard let _ = await apiService.requestAsync(httpRequest) else {
            XCTFail("Shouldn't be nil")
            return
        }
    }
    
    func test_apiService_request_async_returnsBadStatusCodeError() async {
        let apiService = makeSUT()
        let configuration = HTTPRequestConfigurationMock(baseUrl: Locals.baseUrl)
        let httpRequest = HTTPRequestMock(configuration: configuration)
        
        URLProtocolAsyncMock.requestHandler = { request in
            (Locals.data, Locals.badResponse)
        }
        
        guard case .badStatusCode = await apiService.requestAsync(httpRequest) else {
            XCTFail("Shouldn't be .badStatusCode")
            return
        }
    }
    
    func test_apiService_decodableRequest_async_returnsUrlError() async {
        let apiService = makeSUT()
        let configuration = HTTPRequestConfigurationMock(baseUrl: Locals.baseUrl)
        let httpRequest = HTTPRequestDecodableMock<DecodableMock>(configuration: configuration)
        
        URLProtocolAsyncMock.requestHandler = { request in
            throw Locals.notConnectedToInternetError
        }
        
        guard case .failure = await apiService.requestDecodableAsync(httpRequest) else {
            XCTFail("Shouldn't be nil")
            return
        }
    }
    
    func test_apiService_decodableRequest_async_returnsBadStatusCodeError() async {
        let apiService = makeSUT()
        let configuration = HTTPRequestConfigurationMock(baseUrl: Locals.baseUrl)
        let httpRequest = HTTPRequestDecodableMock<DecodableMock>(configuration: configuration)
        
        URLProtocolAsyncMock.requestHandler = { request in
            (Locals.data, Locals.badResponse)
        }
        
        guard case .failure(let apiServiceError) = await apiService.requestDecodableAsync(httpRequest),
              case .badStatusCode = apiServiceError else {
            XCTFail("Shouldn't be .badStatusCode")
            return
        }
    }
    
    func test_apiService_decodableRequest_async_returnsDecodingError() async {
        let apiService = makeSUT()
        let configuration = HTTPRequestConfigurationMock(baseUrl: Locals.baseUrl)
        let httpRequest = HTTPRequestDecodableMock<DecodableMock>(configuration: configuration)
        
        URLProtocolAsyncMock.requestHandler = { request in
            (Locals.junkData, Locals.goodResponse)
        }
        
        guard case .failure(let apiServiceError) = await apiService.requestDecodableAsync(httpRequest),
              case .decodingError = apiServiceError else {
            XCTFail("Shouldn't be .decodingError")
            return
        }
    }
}
