//
//  APIService.swift
//  RickAndMortyTests
//
//  Created by Yan Moroz on 21.03.2024.
//

import Foundation

protocol APIService {
    typealias Completion = (APIServiceError?) -> Void
    func request(_ endpoint: Endpoint, completion: @escaping Completion)
    
    typealias DecodableCompletion<T> = (Result<T, APIServiceError>) -> Void
    func request<T: Decodable, U: DecodableEndpoint>(_ endpoint: U, completion: @escaping DecodableCompletion<T>) where U.DecodeType == T
}
