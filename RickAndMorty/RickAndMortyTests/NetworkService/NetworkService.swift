//
//  NetworkService.swift
//  RickAndMortyTests
//
//  Created by Yan Moroz on 21.03.2024.
//

import Foundation

protocol NetworkService {
    typealias Completion = (Result<Data, NetworkServiceError>) -> Void
    func request(_ urlRequest: URLRequest, completion: @escaping Completion)
}
