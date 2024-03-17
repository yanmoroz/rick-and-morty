//
//  APIServiceError.swift
//  RickAndMorty
//
//  Created by Yan Moroz on 18.03.2024.
//

import Foundation

enum APIServiceError: Error {
    case urlError(URLError)
    case badStatusCode(Int)
    case decodingError(DecodingError)
}
