//
//  HTTPClientDefault.swift
//  RickAndMortyTests
//
//  Created by Yan Moroz on 11.03.2024.
//

import Foundation

class HTTPClientDefault: HTTPClient {
    lazy var urlSession: URLSession = {
        URLSession.shared
    }()
    
    @discardableResult
    func request(_ request: URLRequest, completion: @escaping Completion) -> CancellableTask {
        let task = urlSession.dataTask(with: request) { data, response, error in
            completion(data, response, error as? URLError)
        }
        task.resume()
        return task
    }
}
