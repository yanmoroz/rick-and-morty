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
    var errorResolver: NetworkServiceErrorResolver { get }
    var responseValidator: URLResponseValidator { get }
    
    @discardableResult
    func request(_ request: APIRequest, completion: @escaping Completion) -> CancellableTask
}

protocol NetworkServiceErrorResolver {
    func resolve(_ error: URLError) -> NetworkServiceError
    func resolve(_ error: URLResponseError) -> NetworkServiceError
}

protocol URLResponseValidator {
    func validate(response: URLResponse?) -> URLResponseError?
}

enum URLResponseError: Error {
    case emptyResponse
    case responseIsNotHTTP
    case badStatusCode(Int)
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
    case networkService(NetworkServiceError)
    case decode(Error)
}

protocol DecodableAPIRequest: APIRequest {
    var decoder: ResponseDecoder { get }
}

protocol ResponseDecoder {
    func decode<T>(_ data: Data, toType: T.Type) throws -> T
}

// Global-level
protocol CancellableTask {
    func cancel()
}

extension URLSessionDataTask: CancellableTask { }
