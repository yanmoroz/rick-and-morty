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
    
}
