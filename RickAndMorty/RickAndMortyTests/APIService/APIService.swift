//
//  APIService.swift
//  RickAndMortyTests
//
//  Created by Yan Moroz on 05.04.2024.
//

import Foundation

protocol APIService {
    typealias Completion<T> = (Result<T, APIServiceError>) -> Void
    func request<T: Decodable, E: Endpoint>(
        _ endpoint: E,
        completion: @escaping Completion<T>
    ) where E.DecodeType == T
}
