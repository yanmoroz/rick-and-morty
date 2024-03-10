//
//  HTTPClientMock.swift
//  RickAndMortyTests
//
//  Created by Yan Moroz on 10.03.2024.
//

import Foundation

class HTTPClientMock: HTTPClient {
    lazy var urlSession: URLSession = {
        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [URLProtocolMock.self]
        return URLSession(configuration: configuration)
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
