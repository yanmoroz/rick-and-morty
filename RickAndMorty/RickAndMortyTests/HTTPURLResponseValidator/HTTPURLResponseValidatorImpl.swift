//
//  HTTPURLResponseValidatorImpl.swift
//  RickAndMortyTests
//
//  Created by Yan Moroz on 21.03.2024.
//

import Foundation

class HTTPURLResponseValidatorImpl: HTTPURLResponseValidator {
    func validate(_ httpUrlResponse: HTTPURLResponse) -> HTTPURLResponseValidatorError? {
        guard (200..<300).contains(httpUrlResponse.statusCode) else {
            return .statusCode(httpUrlResponse.statusCode)
        }
        
        return nil
    }
}
