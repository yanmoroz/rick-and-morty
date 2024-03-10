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
    @discardableResult
    func request(_ request: APIRequest, completion: @escaping Completion) -> CancellableTask
}

enum NetworkServiceError: Error {
    case httpClient(URLError)
    case responseIsNotHTTP
    case emptyResponse
    case badStatusCode(Int)
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
    func request<T>(_ request: DecodableAPIRequest, completion: @escaping Completion<T>) -> CancellableTask
}

enum APIServiceError: Error {
    
}

protocol DecodableAPIRequest: APIRequest {
    var decoder: ResponseDecoder { get }
}

protocol ResponseDecoder {
    func decode<T: Decodable>(_ data: Data) -> T
}

// Global-level
protocol CancellableTask {
    func cancel()
}

extension URLSessionDataTask: CancellableTask { }
