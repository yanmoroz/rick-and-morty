//
//  HTTPClient.swift
//  RickAndMortyTests
//
//  Created by Yan Moroz on 21.03.2024.
//

import Foundation

protocol HTTPClient {
    typealias Completion = (Result<(Data, HTTPURLResponse), HTTPClientError>) -> Void
    func request(_ urlRequest: URLRequest, completion: @escaping Completion)
}
