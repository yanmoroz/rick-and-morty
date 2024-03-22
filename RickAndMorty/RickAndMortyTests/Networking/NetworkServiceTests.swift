//
//  NetworkServiceTests.swift
//  RickAndMortyTests
//
//  Created by Yan Moroz on 22.03.2024.
//

import XCTest

final class NetworkServiceTests: XCTestCase {
    enum Mocks {
        static let httpClient = HTTPClientImpl(
            urlSession: {
                let configuration = URLSessionConfiguration.ephemeral
                configuration.protocolClasses = [URLProtocolMock.self]
                return URLSession(configuration: configuration)
            }()
        )
        static let url = URL(string: "https://pepe.com")!
        static let request = URLRequest(url: url)
        static let responseValidator = HTTPURLResponseValidatorImpl()
        static let notConnectedToInternetErrorCode = URLError.notConnectedToInternet
        static let data = "foo".data(using: .utf8)
        static let invalidHttpUrlResponse = HTTPURLResponse(url: url, statusCode: 404)!
        static let validHttpUrlResponse = HTTPURLResponse(url: url, statusCode: 200)!
    }
    
    func test_networkService_onNotConnectedToInternetError_returnsHttpClientError() {
        let sut = NetworkServiceImpl(httpClient: Mocks.httpClient, responseValidator: Mocks.responseValidator)
        let exp = XCTestExpectation()
        
        URLProtocolMock.requestHandler = { _ in
            (nil, nil, URLError(Mocks.notConnectedToInternetErrorCode))
        }
        
        sut.request(Mocks.request) { result in
            defer { exp.fulfill() }
            
            guard case .failure(let networkServiceError) = result,
                  case .httpClientError = networkServiceError else {
                XCTFail("Must be .httpClientError")
                return
            }
        }
        
        wait(for: exp)
    }
    
    func test_networkService_onInvalidHttpUrlResponse_returnsHttpUrlResponseValidatorError() {
        let sut = NetworkServiceImpl(httpClient: Mocks.httpClient, responseValidator: Mocks.responseValidator)
        let exp = XCTestExpectation()
        
        URLProtocolMock.requestHandler = { _ in
            (Mocks.data, Mocks.invalidHttpUrlResponse, nil)
        }
        
        sut.request(Mocks.request) { result in
            defer { exp.fulfill() }
            
            guard case .failure(let networkServiceError) = result,
                  case .httpUrlResponseValidatorError = networkServiceError else {
                XCTFail("Must be .httpUrlResponseValidatorError")
                return
            }
        }
        
        wait(for: exp)
    }
    
    func test_networkService_onSuccessful_() {
        let sut = NetworkServiceImpl(httpClient: Mocks.httpClient, responseValidator: Mocks.responseValidator)
        let exp = XCTestExpectation()
        
        URLProtocolMock.requestHandler = { _ in
            (Mocks.data, Mocks.validHttpUrlResponse, nil)
        }
        
        sut.request(Mocks.request) { result in
            defer { exp.fulfill() }
            
            guard case .success = result else {
                XCTFail("Must be .success")
                return
            }
        }
        
        wait(for: exp)
    }
}
