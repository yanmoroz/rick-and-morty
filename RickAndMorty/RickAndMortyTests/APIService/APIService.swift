//
//  APIService.swift
//  RickAndMortyTests
//
//  Created by Yan Moroz on 05.04.2024.
//

import Foundation

protocol APIService {
    typealias DecodableCompletion<T> = (Result<T, APIServiceError>) -> Void
    typealias Completion = (APIServiceError?) -> Void
    
    func decodableRequest<T: Decodable, E: DecodableEndpoint>(
        _ endpoint: E,
        handler: @escaping DecodableCompletion<T>
    ) where E.DecodeType == T
    
    func request(
        _ endpoint: Endpoint,
        handler: @escaping Completion
    )
}
