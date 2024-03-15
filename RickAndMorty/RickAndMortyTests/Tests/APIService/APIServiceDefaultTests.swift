//
//  APIServiceDefaultTests.swift
//  RickAndMortyTests
//
//  Created by Yan Moroz on 15.03.2024.
//

import XCTest

final class APIServiceDefaultTests: XCTestCase {
    enum Locals {
        private static let baseAddress = "https://rickandmortyapi.com/"
        static let baseUrl = URL(string: baseAddress)!
        private static let badBaseAddress = "https://rickandmortyapi-pepega.com/"
        static let badBaseUrl = URL(string: badBaseAddress)!
        static let path = "/api/"
        static let badPath = "/api/pepege/"
    }
    
    private func makeSUT() -> APIService {
        APIServiceDefault(
            httpClient: HTTPClientDefault(),
            responseValidator: HTTPURLResponseValidatorDefault(),
            responseDecoder: HTTPResponseDecoderDefault()
        )
    }
}

// MARK: - Sync
extension APIServiceDefaultTests {
    func test_apiService_request_cancels() {
        let apiService = makeSUT()
        let configuration = HTTPRequestConfigurationDefault(baseUrl: Locals.baseUrl)
        let httpRequest = HTTPRequestDefault(configuration: configuration)
        let exp = XCTestExpectation()
        
        let task = apiService.request(httpRequest) { error in
            defer {
                exp.fulfill()
            }
            
            guard let error,
                  case .urlError(let urlError) = error,
                  urlError.code == URLError.cancelled
            else {
                XCTFail("Error shouldn't be nil")
                return
            }
        }
        
        task.cancel()
        wait(for: exp)
    }
    
    func test_apiService_decodableRequest_cancels() {
        let apiService = makeSUT()
        let configuration = HTTPRequestConfigurationDefault(baseUrl: Locals.baseUrl)
        let httpRequest = HTTPRequestDecodableDefault<DecodableMock>(configuration: configuration)
        let exp = XCTestExpectation()
        
        let task = apiService.requestDecodable(httpRequest) { result in
            defer {
                exp.fulfill()
            }
            
            guard case .failure(let apiServiceError) = result,
                  case .urlError(let urlError) = apiServiceError,
                  urlError.code == URLError.cancelled
            else {
                XCTFail("Error shouldn't be nil")
                return
            }
        }
        
        task.cancel()
        wait(for: exp)
    }
    
    func test_apiService_request_returnsNilErrorOnSuccess() {
        let apiService = makeSUT()
        let configuration = HTTPRequestConfigurationDefault(baseUrl: Locals.baseUrl)
        let httpRequest = HTTPRequestDefault(configuration: configuration)
        let exp = XCTestExpectation()

        apiService.request(httpRequest) { error in
            defer {
                exp.fulfill()
            }
            
            guard error == nil else {
                XCTFail("Error should be nil")
                return
            }
        }

        wait(for: exp)
    }
    
    func test_apiService_decodableRequest_returnsSmthOnSuccess() {
        let apiService = makeSUT()
        let configuration = HTTPRequestConfigurationDefault(baseUrl: Locals.baseUrl, path: Locals.path)
        let httpRequest = HTTPRequestDecodableDefault<RickAndMortyApiRootResponse>(configuration: configuration)
        let exp = XCTestExpectation()

        apiService.requestDecodable(httpRequest) { result in
            defer {
                exp.fulfill()
            }
            
            guard case .success = result else {
                XCTFail("Should be .success")
                return
            }
        }

        wait(for: exp)
    }
    
    func test_apiService_request_returnsUrlError() {
        let apiService = makeSUT()
        let configuration = HTTPRequestConfigurationDefault(baseUrl: Locals.badBaseUrl)
        let httpRequest = HTTPRequestDefault(configuration: configuration)
        let exp = XCTestExpectation()

        apiService.request(httpRequest) { error in
            defer {
                exp.fulfill()
            }

            guard case .urlError(let urlError) = error,
                  urlError.code == .cannotFindHost
            else {
                XCTFail("Should be .cannotFindHost")
                return
            }
        }

        wait(for: exp)
    }
    
    func test_apiService_request_returnsBadStatusCodeError() {
        let apiService = makeSUT()
        let configuration = HTTPRequestConfigurationDefault(baseUrl: Locals.baseUrl, path: Locals.badPath)
        let httpRequest = HTTPRequestDefault(configuration: configuration)
        let exp = XCTestExpectation()

        apiService.request(httpRequest) { error in
            defer {
                exp.fulfill()
            }

            guard case .badStatusCode = error else {
                XCTFail("Should be .badStatusCode")
                return
            }
        }

        wait(for: exp)
    }
    
    func test_apiService_decodableRequest_returnsUrlError() {
        let apiService = makeSUT()
        let configuration = HTTPRequestConfigurationDefault(baseUrl: Locals.badBaseUrl)
        let httpRequest = HTTPRequestDecodableDefault<DecodableMock>(configuration: configuration)
        let exp = XCTestExpectation()

        apiService.requestDecodable(httpRequest) { result in
            defer {
                exp.fulfill()
            }
            
            guard case .failure(let apiServiceError) = result,
                  case .urlError(let urlError) = apiServiceError,
                  urlError.code == .cannotFindHost
            else {
                XCTFail("Should be .cannotFindHost")
                return
            }
        }

        wait(for: exp)
    }
    
    func test_apiService_decodableRequest_returnsBadStatusCodeError() {
        let apiService = makeSUT()
        let configuration = HTTPRequestConfigurationDefault(baseUrl: Locals.baseUrl, path: Locals.badPath)
        let httpRequest = HTTPRequestDecodableDefault<DecodableMock>(configuration: configuration)
        let exp = XCTestExpectation()

        apiService.requestDecodable(httpRequest) { result in
            defer {
                exp.fulfill()
            }
            
            guard case .failure(let apiServiceError) = result,
                  case .badStatusCode = apiServiceError
            else {
                XCTFail("Should be .cannotFindHost")
                return
            }
        }

        wait(for: exp)
    }
    
    func test_apiService_decodableRequest_returnsDecodingError() {
        let apiService = makeSUT()
        let configuration = HTTPRequestConfigurationDefault(baseUrl: Locals.baseUrl, path: Locals.path)
        let httpRequest = HTTPRequestDecodableDefault<DecodableMock>(configuration: configuration)
        let exp = XCTestExpectation()

        apiService.requestDecodable(httpRequest) { result in
            defer {
                exp.fulfill()
            }
            
            guard case .failure(let apiServiceError) = result,
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
extension APIServiceDefaultTests {
    func test_apiService_request_async_returnsNilErrorOnSuccess() async {
        let apiService = makeSUT()
        let configuration = HTTPRequestConfigurationDefault(baseUrl: Locals.baseUrl)
        let httpRequest = HTTPRequestDefault(configuration: configuration)
        
        guard await apiService.requestAsync(httpRequest) == nil else {
            XCTFail("Should be nil")
            return
        }
    }
    
    func test_apiService_decodableRequest_async_returnsSmthOnSuccess() async {
        let apiService = makeSUT()
        let configuration = HTTPRequestConfigurationDefault(baseUrl: Locals.baseUrl, path: Locals.path)
        let httpRequest = HTTPRequestDecodableDefault<RickAndMortyApiRootResponse>(configuration: configuration)
        
        guard case .success = await apiService.requestDecodableAsync(httpRequest) else {
            XCTFail("Should be success")
            return
        }
    }
    
    func test_apiService_request_async_returnsUrlError() async {
        let apiService = makeSUT()
        let configuration = HTTPRequestConfigurationDefault(baseUrl: Locals.badBaseUrl)
        let httpRequest = HTTPRequestDefault(configuration: configuration)
        
        guard let _ = await apiService.requestAsync(httpRequest) else {
            XCTFail("Shouldn't be nil")
            return
        }
    }
    
    func test_apiService_request_async_returnsBadStatusCodeError() async {
        let apiService = makeSUT()
        let configuration = HTTPRequestConfigurationDefault(baseUrl: Locals.baseUrl, path: Locals.badPath)
        let httpRequest = HTTPRequestDefault(configuration: configuration)
        
        guard case .badStatusCode = await apiService.requestAsync(httpRequest) else {
            XCTFail("Shouldn't be .badStatusCode")
            return
        }
    }
    
    func test_apiService_decodableRequest_async_returnsUrlError() async {
        let apiService = makeSUT()
        let configuration = HTTPRequestConfigurationDefault(baseUrl: Locals.badBaseUrl)
        let httpRequest = HTTPRequestDecodableDefault<DecodableMock>(configuration: configuration)
        
        guard case .failure = await apiService.requestDecodableAsync(httpRequest) else {
            XCTFail("Shouldn't be nil")
            return
        }
    }
    
    func test_apiService_decodableRequest_async_returnsBadStatusCodeError() async {
        let apiService = makeSUT()
        let configuration = HTTPRequestConfigurationDefault(baseUrl: Locals.baseUrl, path: Locals.badPath)
        let httpRequest = HTTPRequestDecodableDefault<DecodableMock>(configuration: configuration)
        
        guard case .failure(let apiServiceError) = await apiService.requestDecodableAsync(httpRequest),
              case .badStatusCode = apiServiceError else {
            XCTFail("Shouldn't be .badStatusCode")
            return
        }
    }
    
    func test_apiService_decodableRequest_async_returnsDecodingError() async {
        let apiService = makeSUT()
        let configuration = HTTPRequestConfigurationDefault(baseUrl: Locals.baseUrl, path: Locals.path)
        let httpRequest = HTTPRequestDecodableDefault<DecodableMock>(configuration: configuration)
        
        guard case .failure(let apiServiceError) = await apiService.requestDecodableAsync(httpRequest),
              case .decodingError = apiServiceError else {
            XCTFail("Shouldn't be .decodingError")
            return
        }
    }
}
