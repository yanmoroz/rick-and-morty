//
//  NetworkServiceTests.swift
//  RickAndMortyTests
//
//  Created by Yan Moroz on 11.03.2024.
//

import XCTest

final class NetworkServiceTests: XCTestCase {
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
