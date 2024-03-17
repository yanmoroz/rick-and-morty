//
//  HTTPClient.swift
//  RickAndMorty
//
//  Created by Yan Moroz on 18.03.2024.
//

import Foundation

protocol HTTPClient {
    var urlSession: URLSession { get }
    var urlSessionAsync: URLSession { get }
    
    typealias Completion = (Result<(Data, HTTPURLResponse), URLError>) -> Void
    
    func request(_ urlRequest: URLRequest, completion: @escaping Completion) -> Cancellable
    func requestAsync(_ urlRequest: URLRequest) async -> Result<(Data, HTTPURLResponse), URLError>
}

extension HTTPClient {
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
