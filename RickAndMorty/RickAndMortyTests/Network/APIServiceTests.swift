//
//  APIServiceTests.swift
//  RickAndMortyTests
//
//  Created by Yan Moroz on 11.03.2024.
//

import XCTest

final class APIServiceTests: XCTestCase {
    
    enum Locals {
        static let baseUrl = URL(string: "https://mock.api.io")!
        static let response = HTTPURLResponse(url: baseUrl, statusCode: 200)
        static let junkData = "foo bad".data(using: .utf8)
        static let validData = #"{"id": 5}"#.data(using: .utf8)
        static let mockObjectId = 5
        static let cancellationError = URLError(URLError.cancelled)
        static let someNetworkServiceError = URLError(URLError.notConnectedToInternet)
    }
    
    func test_apiServiceMock_cancels() {
        let sut = makeMockSUT()
        let request = DecodableAPIRequestMock<DecodableMock>(decoder: ResponseDecoderMock())
        let exp = XCTestExpectation()
        
        URLProtocolMock.requestHandler = { request in
            (nil, nil, nil)
        }
        
        let task = sut.request(request) { result in
            defer {
                exp.fulfill()
            }
            
            guard case let .failure(apiServiceError) = result,
                  case let .networkService(networkServiceError) = apiServiceError,
                  case let .httpClient(urlError) = networkServiceError,
                  urlError.code == Locals.cancellationError.code else {
                XCTFail("Should be .cancelled")
                return
            }
        }
        
        task.cancel()
        wait(for: exp)
    }
    
    func test_apiServiceMock_returnsDecodingError() {
        let sut = makeMockSUT()
        let request = DecodableAPIRequestMock<DecodableMock>(decoder: ResponseDecoderMock())
        let exp = XCTestExpectation()
        
        URLProtocolMock.requestHandler = { request in
            (Locals.junkData, Locals.response, nil)
        }
        
        sut.request(request) { result in
            defer {
                exp.fulfill()
            }
            
            guard case let .failure(apiServiceError) = result,
                  case .decode = apiServiceError else {
                XCTFail("Should be .decode")
                return
            }
        }
        
        wait(for: exp)
    }
    
    func test_apiServiceMock_decodes() {
        let sut = makeMockSUT()
        let request = DecodableAPIRequestMock<DecodableMock>(decoder: ResponseDecoderMock())
        let exp = XCTestExpectation()
        
        URLProtocolMock.requestHandler = { request in
            (Locals.validData, Locals.response, nil)
        }
        
        sut.request(request) { result in
            defer {
                exp.fulfill()
            }
            
            guard case let .success(decoded) = result else {
                XCTFail("Should be decoded")
                return
            }
            
            XCTAssertEqual(decoded.id, Locals.mockObjectId)
        }
        
        wait(for: exp)
    }
    
    func test_apiServiceMock_returnsNetworkServiceError() {
        let sut = makeMockSUT()
        let request = DecodableAPIRequestMock<DecodableMock>(decoder: ResponseDecoderMock())
        let exp = XCTestExpectation()
        
        URLProtocolMock.requestHandler = { request in
            (nil, nil, Locals.someNetworkServiceError)
        }
        
        sut.request(request) { result in
            defer {
                exp.fulfill()
            }
            
            guard case let .failure(apiServiceError) = result,
                  case let .networkService(networkServiceError) = apiServiceError,
                  case let .httpClient(urlError) = networkServiceError,
                  urlError.code == Locals.someNetworkServiceError.code else {
                XCTFail("Should be URLError.notConnectedToInternet")
                return
            }
        }
        
        wait(for: exp)
    }
    
    func makeMockSUT() -> APIService {
        return APIServiceMock(
            networkService: NetworkServiceMock(
                httpClient: HTTPClientMock(),
                apiConfiguration: APIConfigurationMock()
            )
        )
    }
}

extension APIServiceTests {
    func test_apiServiceDefault_cancels() {
        let networkService = NetworkServiceDefault(
            httpClient: HTTPClientDefault(),
            apiConfiguration: APIConfigurationDefault(baseURL: URL(string: "https://rickandmortyapi.com/api/")!)
        )
        let apiService = APIServiceDefault(networkService: networkService)
        let request = APIRequestDefault()
        let exp = XCTestExpectation()
        
        let task = apiService.request(request) { result in
            defer {
                exp.fulfill()
            }
            
            guard case let .failure(apiServiceError) = result,
                  case let .networkService(networkServiceError) = apiServiceError,
                  case let .httpClient(urlError) = networkServiceError,
                  urlError.code == URLError.cancelled else {
                XCTFail("Should be .cancelled")
                return
            }
        }
        
        task.cancel()
        wait(for: exp)
    }
}
