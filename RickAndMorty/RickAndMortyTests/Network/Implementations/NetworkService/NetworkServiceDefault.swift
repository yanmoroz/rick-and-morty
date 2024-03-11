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
    let errorResolver: NetworkServiceErrorResolver
    let responseValidator: URLResponseValidator
    
    func request(_ request: APIRequest, completion: @escaping Completion) -> CancellableTask {
        httpClient.request(request.urlRequest(using: apiConfiguration)) { data, response, urlError in
            if let urlError {
                completion(.failure(errorResolver.resolve(urlError)))
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
