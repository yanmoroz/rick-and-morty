//
//  HTTPURLResponseValidator.swift
//  RickAndMorty
//
//  Created by Yan Moroz on 18.03.2024.
//

import Foundation

protocol HTTPURLResponseValidator {
    func validate(_ httpUrlResponse: HTTPURLResponse) -> APIServiceError?
}

extension HTTPURLResponseValidator {
    func validate(_ httpUrlResponse: HTTPURLResponse) -> APIServiceError? {
        httpUrlResponse.statusCode < 300 ? nil : .badStatusCode(httpUrlResponse.statusCode)
    }
}
