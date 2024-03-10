//
//  NetworkServiceTests.swift
//  RickAndMortyTests
//
//  Created by Yan Moroz on 11.03.2024.
//

import XCTest

final class NetworkServiceTests: XCTestCase {
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
