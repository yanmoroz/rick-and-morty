//
//  HTTPClientMock.swift
//  RickAndMortyTests
//
//  Created by Yan Moroz on 13.03.2024.
//

import Foundation

class HTTPClientMock: HTTPClient {
    private lazy var urlSession: URLSession = {
        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [URLProtocolMock.self]
        return URLSession(configuration: configuration)
    }()
    
    private lazy var urlSessionAsync: URLSession = {
        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [URLProtocolAsyncMock.self]
        return URLSession(configuration: configuration)
    }()
    
    @discardableResult
    func request(_ urlRequest: URLRequest, completion: @escaping Completion) -> Cancellable {
        let task = urlSession.dataTask(with: urlRequest) { data, urlResponse, error in
            if let urlError = error as? URLError {
                completion(.failure(urlError))
                return
            }
            
            if let data, let httpUrlResponse = urlResponse as? HTTPURLResponse {
                completion(.success((data, httpUrlResponse)))
            }
        }
        task.resume()
        return task
    }
    
    func requestAsync(_ urlRequest: URLRequest) async -> Result<(Data, HTTPURLResponse), URLError> {
        do {
            let (data, urlResponse) = try await urlSessionAsync.data(for: urlRequest)
            return .success((data, urlResponse as! HTTPURLResponse))
        } catch {
            return .failure(error as! URLError)
        }
    }
}
