//
//  APIServiceImpl.swift
//  RickAndMortyTests
//
//  Created by Yan Moroz on 05.04.2024.
//

import Foundation

class APIServiceImpl: APIService {
    let networkService: NetworkService
    let decoder: JSONDecoder
    
    init(
        networkService: NetworkService,
        decoder: JSONDecoder
    ) {
        self.networkService = networkService
        self.decoder = decoder
    }
    
    func decodableRequest<T: Decodable, E: DecodableEndpoint>(
        _ endpoint: E,
        handler: @escaping DecodableCompletion<T>
    ) where E.DecodeType == T {
        networkService.request(endpoint.urlRequest) { [weak self] result in
            guard let self else {
                return
            }
            
            switch result {
            case .success(let data):
                if let data {
                    do {
                        let decoded = try self.decoder.decode(T.self, from: data)
                        handler(.success(decoded))
                    } catch let error as DecodingError {
                        handler(.failure(.decodingError(error)))
                    } catch {
                        handler(.failure(.unknown(error)))
                    }
                }
            case .failure(let error):
                handler(.failure(.networkServiceError(error)))
            }
        }
    }
    
    func request(
        _ endpoint: Endpoint,
        handler: @escaping Completion
    ) {
        networkService.request(endpoint.urlRequest) { result in
            switch result {
            case .success:
                handler(nil)
            case .failure(let error):
                handler(.networkServiceError(error))
            }
        }
    }
}
