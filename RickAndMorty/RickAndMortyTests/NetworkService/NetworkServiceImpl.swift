//
//  NetworkServiceImpl.swift
//  RickAndMortyTests
//
//  Created by Yan Moroz on 21.03.2024.
//

import Foundation

class NetworkServiceImpl: NetworkService {
    let httpClient: HTTPClient
    let responseValidator: HTTPURLResponseValidator
    
    init(httpClient: HTTPClient, responseValidator: HTTPURLResponseValidator) {
        self.httpClient = httpClient
        self.responseValidator = responseValidator
    }
    
    func request(_ urlRequest: URLRequest, completion: @escaping Completion) {
        httpClient.request(urlRequest) { [weak self] result in
            guard let self else { return }
            
            switch result {
            case .success(let (data, httpUrlResponse)):
                handleSuccess(data: data, httpUrlResponse: httpUrlResponse, completion: completion)
            case .failure(let httpClientError):
                completion(.failure(.httpClientError(httpClientError)))
            }
        }
    }
    
    private func handleSuccess(data: Data, httpUrlResponse: HTTPURLResponse, completion: @escaping Completion) {
        guard let validationError = self.responseValidator.validate(httpUrlResponse) else {
            completion(.success(data))
            return
        }
        
        completion(.failure(.httpUrlResponseValidatorError(validationError)))
    }
}
