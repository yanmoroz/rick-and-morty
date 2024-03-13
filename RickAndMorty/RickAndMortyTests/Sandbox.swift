//
//  Sandbox.swift
//  RickAndMortyTests
//
//  Created by Yan Moroz on 13.03.2024.
//

import Foundation

protocol HTTPClient {
    typealias Completion = (Data?, URLResponse?, Error?) -> Void
    
    @discardableResult
    func request(_ urlRequest: URLRequest, completion: @escaping Completion) -> Cancellable
}

protocol Cancellable {
    func cancel()
}

extension URLSessionTask: Cancellable { }

protocol HTTPClientAsync {
    func request(_ urlRequest: URLRequest) async throws -> (Data, URLResponse)
}






protocol HTTPRequestConfiguration {
    var baseUrl: String { get }
}

protocol HTTPRequest {
    var configuration: HTTPRequestConfiguration { get }
    
    func urlRequest() -> URLRequest?
}

protocol DecodableHTTPRequest: HTTPRequest {
    associatedtype DecodeType
}

enum APIServiceError: Error {
    case urlError(URLError)
    case urlResponseIsNotHttp(URLResponse?)
    case badStatusCode(Int)
    case decodingError(DecodingError)
    case badRequestConfiguration(HTTPRequestConfiguration)
}

protocol APIService {
    typealias DecodableCompletion<T> = (Result<T, APIServiceError>) -> Void
    typealias Completion = (APIServiceError?) -> Void
    
    func request<T, Request>(_ httpRequest: Request, completion: @escaping DecodableCompletion<T>)
    -> Cancellable? where T: Decodable, Request: DecodableHTTPRequest, Request.DecodeType == T
    func request(_ httpRequest: HTTPRequest, completion: @escaping Completion) -> Cancellable?
}

struct APIServiceMock: APIService {
    let httpClient: HTTPClient
    
    func request<T, Request>(_ httpRequest: Request, completion: @escaping DecodableCompletion<T>)
    -> Cancellable? where T: Decodable, Request: DecodableHTTPRequest, Request.DecodeType == T {
        guard let urlRequest = httpRequest.urlRequest() else {
            completion(.failure(.badRequestConfiguration(httpRequest.configuration)))
            return nil
        }
        
        return httpClient.request(urlRequest) { data, urlResponse, error in
            if let urlError = error as? URLError {
                completion(.failure(.urlError(urlError)))
                return
            }
            
            guard let httpUrlResponse = urlResponse as? HTTPURLResponse else {
                completion(.failure(.urlResponseIsNotHttp(urlResponse)))
                return
            }
            
            if let responseValidationError = validateHttpUrlResponse(httpUrlResponse) {
                completion(.failure(responseValidationError))
                return
            }
            
            if let data {
                switch decode(data) as Result<T, DecodingError> {
                case .success(let decoded):
                    completion(.success(decoded))
                case .failure(let decodingError):
                    completion(.failure(.decodingError(decodingError)))
                }
            }
        }
    }
    
    @discardableResult
    func request(_ httpRequest: HTTPRequest, completion: @escaping Completion) -> Cancellable? {
        guard let urlRequest = httpRequest.urlRequest() else {
            completion(.badRequestConfiguration(httpRequest.configuration))
            return nil
        }
        
        return httpClient.request(urlRequest) { data, urlResponse, error in
            if let urlError = error as? URLError {
                completion(.urlError(urlError))
                return
            }
            
            guard let httpUrlResponse = urlResponse as? HTTPURLResponse else {
                completion(.urlResponseIsNotHttp(urlResponse))
                return
            }
            
            if let responseValidationError = validateHttpUrlResponse(httpUrlResponse) {
                completion(responseValidationError)
                return
            }
            
            completion(nil)
        }
    }
    
    private func validateHttpUrlResponse(_ httpUrlResponse: HTTPURLResponse) -> APIServiceError? {
        return httpUrlResponse.statusCode < 300 ? nil : .badStatusCode(httpUrlResponse.statusCode)
    }
    
    private func decode<T>(_ data: Data) -> Result<T, DecodingError> where T: Decodable {
        let decoder = JSONDecoder()
        do {
            let decoded = try decoder.decode(T.self, from: data)
            return .success(decoded)
        } catch {
            return .failure(error as! DecodingError)
        }
    }
}
