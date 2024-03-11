//
//  NetworkServiceErrorResolverMock.swift
//  RickAndMortyTests
//
//  Created by Yan Moroz on 11.03.2024.
//

import Foundation

struct NetworkServiceErrorResolverMock: NetworkServiceErrorResolver {
    func resolve(_ error: URLError) -> NetworkServiceError {
        .httpClient(error)
    }
    
    func resolve(_ error: URLResponseError) -> NetworkServiceError {
        switch error {
        case .emptyResponse:
            return .emptyResponse
        case .responseIsNotHTTP:
            return .responseIsNotHTTP
        case .badStatusCode(let statusCode):
            return .badStatusCode(statusCode)
        }
    }
}
