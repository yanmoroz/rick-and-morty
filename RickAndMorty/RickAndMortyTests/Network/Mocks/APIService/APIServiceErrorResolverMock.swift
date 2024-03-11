//
//  APIServiceErrorResolverMock.swift
//  RickAndMortyTests
//
//  Created by Yan Moroz on 11.03.2024.
//

import Foundation

struct APIServiceErrorResolverMock: APIServiceErrorResolver {
    func resolve(_ error: NetworkServiceError) -> APIServiceError {
        .networkService(error)
    }
}
