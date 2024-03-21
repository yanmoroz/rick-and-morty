//
//  HTTPClientImpl.swift
//  RickAndMortyTests
//
//  Created by Yan Moroz on 21.03.2024.
//

import Foundation

class HTTPClientImpl: HTTPClient {
    let urlSession: URLSession
    
    init(urlSession: URLSession = URLSession.shared) {
        self.urlSession = urlSession
    }
    
    func request(_ urlRequest: URLRequest, completion: @escaping Completion) {
        let task = urlSession.dataTask(with: urlRequest) { data, urlResponse, error in
            if let urlError = error as? URLError {
                completion(.failure(.urlError(urlError)))
                return
            }
            
            guard let data, let httpUrlResponse = urlResponse as? HTTPURLResponse else {
                completion(.failure(.unexpectedError))
                return
            }
            
            completion(.success((data, httpUrlResponse)))
        }
        
        task.resume()
    }
}
