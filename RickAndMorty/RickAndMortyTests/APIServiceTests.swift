//
//  APIServiceTests.swift
//  RickAndMortyTests
//
//  Created by Yan Moroz on 11.03.2024.
//

import XCTest

final class APIServiceTests: XCTestCase {
    
    func makeSUT() -> APIService {
        return APIServiceMock(
            networkService: NetworkServiceMock(
                httpClient: HTTPClientMock(),
                apiConfiguration: APIConfigurationMock(),
                errorResolver: NetworkServiceErrorResolverMock(),
                responseValidator: URLResponseValidatorMock()
            ),
            errorResolver: APIServiceErrorResolverMock()
        )
    }
}
