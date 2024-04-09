//
//  NetworkService.swift
//  RickAndMortyTests
//
//  Created by Yan Moroz on 05.04.2024.
//

import Foundation

protocol NetworkService {
    typealias Completion = (Result<Data?, NetworkServiceError>) -> Void
    func request(
        _ urlRequest: URLRequest,
        handler: @escaping Completion
    )
}
