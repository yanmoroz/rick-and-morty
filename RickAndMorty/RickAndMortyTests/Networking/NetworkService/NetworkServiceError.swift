//
//  NetworkServiceError.swift
//  RickAndMortyTests
//
//  Created by Yan Moroz on 21.03.2024.
//

import Foundation

enum NetworkServiceError: Error {
    case httpClientError(HTTPClientError)
    case httpUrlResponseValidatorError(HTTPURLResponseValidatorError)
}
