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
    }
    
    func test_networkServiceMock_returnsEmptyResponseError() {
        let sut = makeSUT()
        let request = APIRequestMock()
        let exp = XCTestExpectation()
        
        URLProtocolMock.requestHandler = { request in
            (nil, nil, nil)
        }
        
        sut.request(request) { result in
            switch result {
            case .success:
                XCTFail("Shouldn't be succeed")
            case .failure(let error):
                switch error {
                case .emptyResponse:
                    break
                default:
                    XCTFail("Should be .emptyResponse")
                }
            }
            exp.fulfill()
        }
        
        wait(for: exp)
    }
    
    func test_networkServiceMock_returnsResponseIsNotHTTPError() {
        let sut = makeSUT()
        let request = APIRequestMock()
        let exp = XCTestExpectation()
        
        URLProtocolMock.requestHandler = { request in
            return (nil, URLResponse(), nil)
        }
        
        sut.request(request) { result in
            switch result {
            case .success:
                XCTFail("Shouldn't be succeed")
            case .failure(let error):
                switch error {
                case .responseIsNotHTTP:
                    break
                default:
                    XCTFail("Should be .responseIsNotHTTP")
                }
            }
            exp.fulfill()
        }
        
        wait(for: exp)
    }
    
    func test_networkServiceMock_returnBadStatusCodeError() {
        let sut = makeSUT()
        let request = APIRequestMock()
        let exp = XCTestExpectation()
        
        URLProtocolMock.requestHandler = { request in
            let response = HTTPURLResponse(url: Locals.baseUrl, statusCode: Locals.badStatusCode)
            return (nil, response, nil)
        }
        
        sut.request(request) { result in
            switch result {
            case .success:
                XCTFail("Shouldn't be succeed")
            case .failure(let error):
                switch error {
                case .badStatusCode:
                    break
                default:
                    XCTFail("Should be .badStatusCode")
                }
            }
            exp.fulfill()
        }
        
        wait(for: exp)
    }
    
    func makeSUT() -> NetworkService {
        let httpClient = HTTPClientMock()
        let apiConfiguration = APIConfigurationMock()
        let errorResolver = NetworkServiceErrorResolverMock()
        let responseValidator = URLResponseValidatorMock()
        let sut = NetworkServiceMock(
            httpClient: httpClient,
            apiConfiguration: apiConfiguration,
            errorResolver: errorResolver,
            responseValidator: responseValidator
        )
        
        return sut
    }
}
