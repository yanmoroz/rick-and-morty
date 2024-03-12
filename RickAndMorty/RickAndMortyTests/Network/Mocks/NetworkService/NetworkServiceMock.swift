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
    
    @discardableResult
    func request(_ request: APIRequest, completion: @escaping Completion) -> CancellableTask {
        httpClient.request(request.urlRequest(using: apiConfiguration)) { data, response, urlError in
            if let urlError {
                completion(.failure(NetworkServiceError(urlError)))
                return
            }
            
            if let responseValidationError = NetworkServiceError(response) {
                completion(.failure(responseValidationError))
                return
            }
            
            if let data {
                completion(.success(data))
            }
        }
    }
}
