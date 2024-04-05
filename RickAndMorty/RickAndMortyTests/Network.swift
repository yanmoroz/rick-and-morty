//
//  Network.swift
//  RickAndMortyTests
//
//  Created by Yan Moroz on 05.04.2024.
//

import Foundation

protocol APIService {
    typealias Completion<T> = (Result<T, Error>) -> Void
    func request<T: Decodable, E: Endpoint>(
        _ endpoint: E,
        completion: @escaping Completion<T>
    ) where E.DecodeType == T
}

class APIServiceImpl: APIService {
    func request<T: Decodable, E: Endpoint>(
        _ endpoint: E,
        completion: @escaping Completion<T>
    ) where E.DecodeType == T {
        URLSession.shared.dataTask(with: endpoint.urlRequest) { data, _, error in
            if let error {
                completion(.failure(error))
                return
            }
            
            // validate response
            
            if let data {
                let decoded = try! JSONDecoder().decode(T.self, from: data)
                completion(.success(decoded))
            }
        }.resume()
    }
}

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
