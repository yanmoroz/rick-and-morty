//
//  HTTPClientMock.swift
//  RickAndMortyTests
//
//  Created by Yan Moroz on 13.03.2024.
//

import Foundation

class HTTPClientMock: HTTPClient {
    lazy var urlSession: URLSession = {
        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [URLProtocolMock.self]
        return URLSession(configuration: configuration)
    }()
    
    @discardableResult
    func request(_ urlRequest: URLRequest, completion: @escaping Completion) -> Cancellable {
        let task = urlSession.dataTask(with: urlRequest) { data, urlResponse, error in
            completion(data, urlResponse, error)
        }
        task.resume()
        return task
    }
}
