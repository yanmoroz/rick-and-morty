//
//  APIServiceImpl.swift
//  RickAndMortyTests
//
//  Created by Yan Moroz on 05.04.2024.
//

import Foundation

class APIServiceImpl: APIService {
    let networkService: NetworkService
    
    init(networkService: NetworkService) {
        self.networkService = networkService
    }
    
    func decodableRequest<T: Decodable, E: DecodableEndpoint>(
        _ endpoint: E,
        completion: @escaping DecodableCompletion<T>
    ) where E.DecodeType == T {
        networkService.request(endpoint.urlRequest) { result in
            switch result {
            case .success(let data):
                if let data {
                    do {
                        let decoded = try JSONDecoder().decode(T.self, from: data)
                        completion(.success(decoded))
                    } catch let error as DecodingError {
                        completion(.failure(.decodingError(error)))
                    } catch {
                        completion(.failure(.unknown(error)))
                    }
                }
            case .failure(let error):
                completion(.failure(.networkServiceError(error)))
            }
        }
    }
    
    func request(
        _ endpoint: Endpoint,
        completion: @escaping Completion
    ) {
        networkService.request(endpoint.urlRequest) { result in
            switch result {
            case .success:
                completion(nil)
            case .failure(let error):
                completion(.networkServiceError(error))
            }
        }
    }
}
