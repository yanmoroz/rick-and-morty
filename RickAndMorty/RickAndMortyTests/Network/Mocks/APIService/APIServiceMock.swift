//
//  APIServiceMock.swift
//  RickAndMortyTests
//
//  Created by Yan Moroz on 11.03.2024.
//

import Foundation

struct APIServiceMock: APIService {
    let networkService: NetworkService
    
    @discardableResult
    func request<T: Decodable, Request: DecodableAPIRequest>(_ request: Request, completion: @escaping Completion<T>)
    -> CancellableTask where Request.DecodeTargetType == T {
        networkService.request(request) { result in
            switch result {
            case .success(let data):
                let decodeResult = request.decoder.decode(data, toType: T.self)
                switch decodeResult {
                case .success(let decoded):
                    completion(.success(decoded))
                case .failure(let decodingError):
                    completion(.failure(APIServiceError(decodingError)))
                }
            case .failure(let networkServiceError):
                completion(.failure(APIServiceError(networkServiceError)))
            }
        }
    }
    
    func request(_ request: APIRequest, completion: @escaping NeverCompletion) -> CancellableTask {
        networkService.request(request) { result in
            switch result {
            case .success:
                break
            case .failure(let networkServiceError):
                completion(.failure(APIServiceError(networkServiceError)))
            }
        }
    }
}
