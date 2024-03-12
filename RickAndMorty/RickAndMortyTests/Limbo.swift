//
//  Limbo.swift
//  RickAndMortyTests
//
//  Created by Yan Moroz on 10.03.2024.
//

import Foundation

// 1-level
protocol HTTPClient {
    typealias Completion = (Data?, URLResponse?, URLError?) -> Void
    
    func request(_ request: URLRequest, completion: @escaping Completion) -> CancellableTask
}

// 2-level
protocol NetworkService {
    typealias Completion = (Result<Data, NetworkServiceError>) -> Void
    
    var httpClient: HTTPClient { get }
    var apiConfiguration: APIConfiguration { get }
    
    @discardableResult
    func request(_ request: APIRequest, completion: @escaping Completion) -> CancellableTask
}

enum NetworkServiceError: Error {
    case httpClient(URLError)
    case responseIsNotHTTP
    case emptyResponse
    case badStatusCode(Int)
    
    init(_ urlError: URLError) {
        self = .httpClient(urlError)
    }
    
    init?(_ urlResponse: URLResponse?) {
        guard let urlResponse else {
            self = .emptyResponse
            return
        }
        
        guard let httpResponse = urlResponse as? HTTPURLResponse else {
            self = .responseIsNotHTTP
            return
        }
        
        guard httpResponse.statusCode < 300 else {
            self = .badStatusCode(httpResponse.statusCode)
            return
        }
        
        return nil
    }
}

protocol APIRequest {
    func urlRequest(using apiConfiguration: APIConfiguration) -> URLRequest
}

protocol APIConfiguration {
    var baseURL: URL { get }
}

// 3-level
protocol APIService {
    typealias Completion<T> = (Result<T, APIServiceError>) -> Void
    typealias NeverCompletion = (Result<Never, APIServiceError>) -> Void
    
    var networkService: NetworkService { get }
    
    @discardableResult
    func request<T: Decodable, Request: DecodableAPIRequest>(_ request: Request, completion: @escaping Completion<T>)
    -> CancellableTask where Request.DecodeTargetType == T
}

enum APIServiceError: Error {
    case networkService(NetworkServiceError)
    case decoding(DecodingError)
    
    init(_ networkServiceError: NetworkServiceError) {
        self = .networkService(networkServiceError)
    }
    
    init(_ decodingError: DecodingError) {
        self = .decoding(decodingError)
    }
}

protocol DecodableAPIRequest: APIRequest {
    associatedtype DecodeTargetType
    var decoder: ResponseDecoder { get }
}

protocol ResponseDecoder {
    func decode<T: Decodable>(_ data: Data, toType: T.Type) -> Result<T, DecodingError>
}

// Global-level
protocol CancellableTask {
    func cancel()
}

extension URLSessionDataTask: CancellableTask { }
