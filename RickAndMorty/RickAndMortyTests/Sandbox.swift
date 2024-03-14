//
//  Sandbox.swift
//  RickAndMortyTests
//
//  Created by Yan Moroz on 13.03.2024.
//

import Foundation

protocol HTTPClient {
    typealias Completion = (Result<(Data, HTTPURLResponse), URLError>) -> Void
    
    @discardableResult
    func request(_ urlRequest: URLRequest, completion: @escaping Completion) -> Cancellable
    
    @discardableResult
    func requestAsync(_ urlRequest: URLRequest) async -> Result<(Data, HTTPURLResponse), URLError>
}

protocol Cancellable {
    func cancel()
}

extension URLSessionTask: Cancellable { }







protocol HTTPRequestConfiguration {
    var baseUrl: URL { get }
    var path: String? { get }
}

protocol HTTPRequest {
    var configuration: HTTPRequestConfiguration { get }
    var urlRequest: URLRequest { get }
}

extension HTTPRequest {
    var urlRequest: URLRequest {
        URLRequest(url: configuration.baseUrl)
    }
}

protocol DecodableHTTPRequest: HTTPRequest {
    associatedtype DecodeType
}

enum APIServiceError: Error {
    case urlError(URLError)
    case badStatusCode(Int)
    case decodingError(DecodingError)
}

protocol APIService {
    typealias DecodableCompletion<T> = (Result<T, APIServiceError>) -> Void
    typealias Completion = (APIServiceError?) -> Void
    
    func request<T, Request>(_ httpRequest: Request, completion: @escaping DecodableCompletion<T>)
    -> Cancellable where T: Decodable, Request: DecodableHTTPRequest, Request.DecodeType == T
    func request(_ httpRequest: HTTPRequest, completion: @escaping Completion) -> Cancellable
    
    func requestAsync<T, Request>(_ httpRequest: Request) async
    -> Result<T, APIServiceError> where T: Decodable, Request: DecodableHTTPRequest, Request.DecodeType == T
    func requestAsync(_ httpRequest: HTTPRequest) async -> APIServiceError?
}
