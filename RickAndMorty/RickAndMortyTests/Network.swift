//
//  Network.swift
//  RickAndMortyTests
//
//  Created by Yan Moroz on 05.04.2024.
//

import Foundation

enum APIServiceError: Error {
    case networkServiceError(NetworkServiceError)
    case decodingError(DecodingError)
    case unknown(Error)
}

protocol APIService {
    typealias Completion<T> = (Result<T, APIServiceError>) -> Void
    func request<T: Decodable, E: Endpoint>(
        _ endpoint: E,
        completion: @escaping Completion<T>
    ) where E.DecodeType == T
}

class APIServiceImpl: APIService {
    let networkService: NetworkService
    
    init(networkService: NetworkService) {
        self.networkService = networkService
    }
    
    func request<T: Decodable, E: Endpoint>(
        _ endpoint: E,
        completion: @escaping Completion<T>
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
}

// (Data?, URLResponse?, Error?)        - URLSession
// -->
// Result<Data?, NetworkServiceError>   - NetworkService
// -->
// Result<T, APIService>                - APIService

protocol Endpoint {
    associatedtype DecodeType
    
    var urlRequest: URLRequest { get }
}

struct EndpointImpl<DecodeType>: Endpoint {
    typealias DecodeType = DecodeType
    
    var urlRequest: URLRequest
}

struct ResourcesResponse: Decodable {
    let episodes: URL
    let locations: URL
    let characters: URL
}
