//
//  NetworkServiceDefault.swift
//  RickAndMortyTests
//
//  Created by Yan Moroz on 11.03.2024.
//

import Foundation

struct NetworkServiceDefault: NetworkService {
    let httpClient: HTTPClient
    let apiConfiguration: APIConfiguration
    let responseValidator: URLResponseValidator
    
    func request(_ request: APIRequest, completion: @escaping Completion) -> CancellableTask {
        httpClient.request(request.urlRequest(using: apiConfiguration)) { data, response, urlError in
            if let urlError {
                completion(.failure(NetworkServiceError(urlError)))
                return
            }
            
            if let responseValidationError = responseValidator.validate(response: response) {
                completion(.failure(NetworkServiceError(responseValidationError)))
                return
            }
            
            if let data {
                completion(.success(data))
            }
        }
    }
}
