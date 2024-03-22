//
//  APIService.swift
//  RickAndMortyTests
//
//  Created by Yan Moroz on 21.03.2024.
//

import Foundation

protocol APIService {
    typealias Completion<T> = (Result<Decodable, APIServiceError>) -> Void
    func request<T: Decodable, U: Endpoint>(_ endpoint: U, completion: @escaping Completion<T>) where U.DecodeType == T
}
