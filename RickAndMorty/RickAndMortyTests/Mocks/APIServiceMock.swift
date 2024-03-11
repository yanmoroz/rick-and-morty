//
//  APIServiceMock.swift
//  RickAndMortyTests
//
//  Created by Yan Moroz on 11.03.2024.
//

import Foundation

struct APIServiceMock: APIService {
    let networkService: NetworkService
    let errorResolver: APIServiceErrorResolver
    
    func request<T>(_ request: DecodableAPIRequest, completion: @escaping Completion<T>) -> CancellableTask {
        networkService.request(request) { result in
            switch result {
            case .success(let data):
                let decodeResult: Result<T, Error> = decode(data, using: request.decoder)
                switch decodeResult {
                case .success(let decoded):
                    completion(.success(decoded))
                case .failure(let error):
                    completion(.failure(.decode(error)))
                }
            case .failure(let error):
                completion(.failure(errorResolver.resolve(error)))
            }
        }
    }
    
    private func decode<T>(_ data: Data, using decoder: ResponseDecoder) -> Result<T, Error> {
        do {
            let decoded: T = try decoder.decode(data)
            return .success(decoded)
        } catch {
            return .failure(error)
        }
    }
}

protocol APIServiceErrorResolver {
    func resolve(_ error: NetworkServiceError) -> APIServiceError
}

struct APIServiceErrorResolverMock: APIServiceErrorResolver {
    func resolve(_ error: NetworkServiceError) -> APIServiceError {
        .networkService(error)
    }
}
