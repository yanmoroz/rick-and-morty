//
//  HTTPURLResponseValidatorError.swift
//  RickAndMortyTests
//
//  Created by Yan Moroz on 21.03.2024.
//

import Foundation

enum HTTPURLResponseValidatorError: Error {
    case statusCode(Int)
}
