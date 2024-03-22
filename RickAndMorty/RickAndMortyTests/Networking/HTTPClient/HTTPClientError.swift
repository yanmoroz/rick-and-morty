//
//  HTTPClientError.swift
//  RickAndMortyTests
//
//  Created by Yan Moroz on 21.03.2024.
//

import Foundation

enum HTTPClientError: Error {
    case urlError(URLError)
    case unexpectedError
}
