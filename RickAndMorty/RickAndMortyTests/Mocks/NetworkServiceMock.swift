//
//  NetworkServiceMock.swift
//  RickAndMortyTests
//
//  Created by Yan Moroz on 10.03.2024.
//

import Foundation

struct NetworkServiceMock: NetworkService {
    let httpClient: HTTPClient
    let apiConfiguration: APIConfiguration
    let errorResolver: NetworkServiceErrorResolver
    let responseValidator: URLResponseValidator
    
    @discardableResult
    func request(_ request: APIRequest, completion: @escaping Completion) -> CancellableTask {
        httpClient.request(request.urlRequest(using: apiConfiguration)) { data, response, error in
            if let error {
                completion(.failure(errorResolver.resolve(error)))
                return
            }
            
            if let responseError = responseValidator.validate(response: response) {
                completion(.failure(errorResolver.resolve(responseError)))
                return
            }
            
            if let data {
                completion(.success(data))
            }
        }
    }
}

protocol NetworkServiceErrorResolver {
    func resolve(_ error: URLError) -> NetworkServiceError
    func resolve(_ error: URLResponseError) -> NetworkServiceError
}

protocol URLResponseValidator {
    func validate(response: URLResponse?) -> URLResponseError?
}

enum URLResponseError: Error {
    case emptyResponse
    case responseIsNotHTTP
    case badStatusCode(Int)
}

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

struct NetworkServiceErrorResolverMock: NetworkServiceErrorResolver {
    func resolve(_ error: URLError) -> NetworkServiceError {
        .httpClient(error)
    }
    
    func resolve(_ error: URLResponseError) -> NetworkServiceError {
        switch error {
        case .emptyResponse:
            return .emptyResponse
        case .responseIsNotHTTP:
            return .responseIsNotHTTP
        case .badStatusCode(let statusCode):
            return .badStatusCode(statusCode)
        }
    }
}
