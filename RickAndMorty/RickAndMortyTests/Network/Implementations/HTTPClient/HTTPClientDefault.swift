//
//  HTTPClientDefault.swift
//  RickAndMortyTests
//
//  Created by Yan Moroz on 11.03.2024.
//

import Foundation

class HTTPClientDefault: HTTPClient {
    lazy var urlSession: URLSession = {
        guard let urlSessionConfiguration else {
            return URLSession.shared
        }
        
        return URLSession(configuration: urlSessionConfiguration)
    }()
    
    let urlSessionConfiguration: URLSessionConfiguration?
    
    init(urlSessionConfiguration: URLSessionConfiguration? = nil) {
        self.urlSessionConfiguration = urlSessionConfiguration
    }
    
    @discardableResult
    func request(_ request: URLRequest, completion: @escaping Completion) -> CancellableTask {
        let task = urlSession.dataTask(with: request) { data, response, error in
            completion(data, response, error as? URLError)
        }
        task.resume()
        return task
    }
}
