//
//  Limbo.swift
//  RickAndMortyTests
//
//  Created by Yan Moroz on 10.03.2024.
//

import Foundation

// 1-level
protocol HTTPClient {
    typealias Completion = (Data?, URLResponse?, Error?) -> Void
    func request(_ request: URLRequest, completion: @escaping Completion) -> CancellableTask
}

protocol CancellableTask {
    func cancel()
}
