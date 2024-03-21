//
//  HTTPURLResponseValidator.swift
//  RickAndMortyTests
//
//  Created by Yan Moroz on 21.03.2024.
//

import Foundation

protocol HTTPURLResponseValidator {
    func validate(_ httpUrlResponse: HTTPURLResponse) -> HTTPURLResponseValidatorError?
}
