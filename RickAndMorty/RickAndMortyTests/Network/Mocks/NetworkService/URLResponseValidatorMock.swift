//
//  URLResponseValidatorMock.swift
//  RickAndMortyTests
//
//  Created by Yan Moroz on 11.03.2024.
//

import Foundation

struct URLResponseValidatorMock: URLResponseValidator {
    func validate(response: URLResponse?) -> URLResponseError? {
        guard let response else {
            return .emptyResponse
        }
        
        guard let httpResponse = response as? HTTPURLResponse else {
            return .responseIsNotHTTP
        }
        
        return httpResponse.statusCode < 300 ? nil : .badStatusCode(httpResponse.statusCode)
    }
}
