//
//  APIServiceError.swift
//  RickAndMortyTests
//
//  Created by Yan Moroz on 22.03.2024.
//

import Foundation

enum APIServiceError: Error {
    case networkServiceError(NetworkServiceError)
    case endpointError(EndpointError)
    case decodingError(DecodingError)
}
