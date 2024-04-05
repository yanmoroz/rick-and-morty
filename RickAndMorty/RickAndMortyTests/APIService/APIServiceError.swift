//
//  APIServiceError.swift
//  RickAndMortyTests
//
//  Created by Yan Moroz on 05.04.2024.
//

import Foundation

enum APIServiceError: Error {
    case networkServiceError(NetworkServiceError)
    case decodingError(DecodingError)
    case unknown(Error)
}
