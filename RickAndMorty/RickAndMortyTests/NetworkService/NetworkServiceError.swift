//
//  NetworkServiceError.swift
//  RickAndMortyTests
//
//  Created by Yan Moroz on 05.04.2024.
//

import Foundation

enum NetworkServiceError: Error {
    case urlError(URLError)
    case serverError(statusCode: Int, response: URLResponse?)
}
