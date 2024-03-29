//
//  NetworkServiceTests.swift
//  RickAndMortyTests
//
//  Created by Yan Moroz on 11.03.2024.
//

import XCTest

final class NetworkServiceTests: XCTestCase {
    
    enum Locals {
        static let baseUrl = URL(string: "https://mock.api.io")!
        static let badStatusCode = 404
        static let cancellationError = URLError(URLError.cancelled)
        static let notConnectedToInternet = URLError(URLError.notConnectedToInternet)
        static let data = "foo bar".data(using: .utf8)
    }
    
    func test_networkServiceMock_cancels() {
        let sut = makeMockSUT()
        let request = APIRequestMock()
        let exp = XCTestExpectation()
        
        URLProtocolMock.requestHandler = { request in
            (nil, nil, nil)
        }
        
        let task = sut.request(request) { result in
            defer {
                exp.fulfill()
            }
            
            guard case let .failure(networkServiceError) = result,
                  case let .httpClient(urlError) = networkServiceError,
                  case .cancelled = urlError.code else {
                XCTFail("Should be .cancellationError")
                return
            }
        }
        
        task.cancel()
        wait(for: exp)
    }
    
    func test_networkServiceMock_returnsData() {
        let sut = makeMockSUT()
        let request = APIRequestMock()
        let exp = XCTestExpectation()
        
        URLProtocolMock.requestHandler = { request in
            let response = HTTPURLResponse(url: Locals.baseUrl, statusCode: 200)
            return (Locals.data, response, nil)
        }
        
        sut.request(request) { result in
            defer {
                exp.fulfill()
            }
            
            guard case let .success(data) = result else {
                XCTFail("Shouldn't be fail")
                return
            }
            
            XCTAssertEqual(data, Locals.data)
        }
        
        wait(for: exp)
    }
    
    func test_networkServiceMock_returnsEmptyResponseError() {
        let sut = makeMockSUT()
        let request = APIRequestMock()
        let exp = XCTestExpectation()
        
        URLProtocolMock.requestHandler = { request in
            (nil, nil, nil)
        }
        
        sut.request(request) { result in
            defer {
                exp.fulfill()
            }
            
            guard case .failure(let networkServiceError) = result,
                  case .emptyResponse = networkServiceError else {
                XCTFail("Should be .emptyResponse")
                return
            }
        }
        
        wait(for: exp)
    }
    
    func test_networkServiceMock_returnsResponseIsNotHTTPError() {
        let sut = makeMockSUT()
        let request = APIRequestMock()
        let exp = XCTestExpectation()
        
        URLProtocolMock.requestHandler = { request in
            (nil, URLResponse(), nil)
        }
        
        sut.request(request) { result in
            defer {
                exp.fulfill()
            }
            
            guard case .failure(let networkServiceError) = result,
                  case .responseIsNotHTTP = networkServiceError else {
                XCTFail("Should be .responseIsNotHTTP")
                return
            }
        }
        
        wait(for: exp)
    }
    
    func test_networkServiceMock_returnsBadStatusCodeError() {
        let sut = makeMockSUT()
        let request = APIRequestMock()
        let exp = XCTestExpectation()
        
        URLProtocolMock.requestHandler = { request in
            let response = HTTPURLResponse(url: Locals.baseUrl, statusCode: Locals.badStatusCode)
            return (nil, response, nil)
        }
        
        sut.request(request) { result in
            defer {
                exp.fulfill()
            }
            
            guard case .failure(let networkServiceError) = result,
                  case .badStatusCode = networkServiceError else {
                XCTFail("Should be .badStatusCode")
                return
            }
        }
        
        wait(for: exp)
    }
    
    func test_networkServiceMock_returnsHttpClientError() {
        let sut = makeMockSUT()
        let request = APIRequestMock()
        let exp = XCTestExpectation()
        
        URLProtocolMock.requestHandler = { request in
            (nil, nil, Locals.notConnectedToInternet)
        }
        
        sut.request(request) { result in
            defer {
                exp.fulfill()
            }
            
            guard case .failure(let networkServiceError) = result,
                  case let .httpClient(urlError) = networkServiceError,
                  case .notConnectedToInternet = urlError.code else {
                XCTFail("Should be .notConnectedToInternet")
                return
            }
        }
        
        wait(for: exp)
    }
    
    func makeMockSUT() -> NetworkService {
        NetworkServiceMock(
            httpClient: HTTPClientMock(),
            apiConfiguration: APIConfigurationMock()
        )
    }
}

extension NetworkServiceTests {
    func test_networkServiceDefault_cancels() {
        let networkService = makeDefaultSUT()
        let request = APIRequestDefault()
        let exp = XCTestExpectation()
        
        let task = networkService.request(request) { result in
            defer {
                exp.fulfill()
            }
            
            guard case let .failure(networkServiceError) = result,
                  case let .httpClient(urlError) = networkServiceError else {
                XCTFail("Shouldn't be fail")
                return
            }
            
            XCTAssertEqual(urlError.code, URLError.cancelled)
        }
        
        task.cancel()
        wait(for: exp)
    }
    
    func test_networkServiceDefault_returnsData() {
        let networkService = makeDefaultSUT()
        let request = APIRequestDefault()
        let exp = XCTestExpectation()
        
        networkService.request(request) { result in
            defer {
                exp.fulfill()
            }
            
            guard case let .success(data) = result else {
                XCTFail("Shouldn't be fail")
                return
            }
            
            XCTAssertNotNil(data)
        }
        
        wait(for: exp)
    }
    
    func test_networkServiceDefault_returnsBadStatusCodeError() {
        let networkService = makeDefaultSUT(baseURLString: "https://rickandmortyapi.com/api/pepega")
        let request = APIRequestDefault()
        let exp = XCTestExpectation()
        
        networkService.request(request) { result in
            defer {
                exp.fulfill()
            }
            
            guard case let .failure(networkServiceError) = result,
                  case let .badStatusCode(statusCode) = networkServiceError else {
                XCTFail("Shouldn't be fail")
                return
            }
            
            XCTAssertTrue(statusCode > 200)
        }
        
        wait(for: exp)
    }
    
    func test_networkServiceDefault_returnsHttpClientError() {
        let networkService = makeDefaultSUT(baseURLString: "https://rickandmortyapi-pepega.com/api/")
        let request = APIRequestDefault()
        let exp = XCTestExpectation()
        
        networkService.request(request) { result in
            defer {
                exp.fulfill()
            }
            
            guard case let .failure(networkServiceError) = result,
                  case let .httpClient(urlError) = networkServiceError else {
                XCTFail("Shouldn't be fail")
                return
            }
            
            XCTAssertNotNil(urlError)
        }
        
        wait(for: exp)
    }
    
    func makeDefaultSUT(baseURLString: String = "https://rickandmortyapi.com/api/") -> NetworkService {
        NetworkServiceDefault(
            httpClient: HTTPClientDefault(),
            apiConfiguration: APIConfigurationDefault(baseURL: URL(string: baseURLString)!)
        )
    }
}
