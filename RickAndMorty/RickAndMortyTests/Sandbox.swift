//
//  Sandbox.swift
//  RickAndMortyTests
//
//  Created by Yan Moroz on 13.03.2024.
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
    var httpClient: HTTPClient { get }
    var responseValidator: HTTPURLResponseValidator { get }
    var responseDecoder: HTTPResponseDecoder { get }
    
    typealias DecodableCompletion<T> = (Result<T, APIServiceError>) -> Void
    typealias Completion = (APIServiceError?) -> Void
    
    @discardableResult
    func requestDecodable<T, Request>(_ httpRequest: Request, completion: @escaping DecodableCompletion<T>)
    -> Cancellable where T: Decodable, Request: DecodableHTTPRequest, Request.DecodeType == T
    @discardableResult
    func request(_ httpRequest: HTTPRequest, completion: @escaping Completion) -> Cancellable
    
    func requestDecodableAsync<T, Request>(_ httpRequest: Request) async
    -> Result<T, APIServiceError> where T: Decodable, Request: DecodableHTTPRequest, Request.DecodeType == T
    func requestAsync(_ httpRequest: HTTPRequest) async -> APIServiceError?
}

protocol HTTPURLResponseValidator {
    func validate(_ httpUrlResponse: HTTPURLResponse) -> APIServiceError?
}

extension HTTPURLResponseValidator {
    func validate(_ httpUrlResponse: HTTPURLResponse) -> APIServiceError? {
        httpUrlResponse.statusCode < 300 ? nil : .badStatusCode(httpUrlResponse.statusCode)
    }
}

extension APIService {
    @discardableResult
    func requestDecodable<T, Request>(_ httpRequest: Request, completion: @escaping DecodableCompletion<T>)
    -> Cancellable where T: Decodable, Request: DecodableHTTPRequest, Request.DecodeType == T {
        httpClient.request(httpRequest.urlRequest) { result in
            switch result {
            case .success(let (data, httpUrlResponse)):
                if let responseValidationError = responseValidator.validate(httpUrlResponse) {
                    completion(.failure(responseValidationError))
                    return
                }
                
                switch responseDecoder.decode(data) as Result<T, DecodingError> {
                case .success(let decoded):
                    completion(.success(decoded))
                case .failure(let decodingError):
                    completion(.failure(.decodingError(decodingError)))
                }
            case .failure(let urlError):
                completion(.failure(.urlError(urlError)))
                return
            }
        }
    }
    
    @discardableResult
    func request(_ httpRequest: HTTPRequest, completion: @escaping Completion) -> Cancellable {
        httpClient.request(httpRequest.urlRequest) { result in
            switch result {
            case .success(let (_, httpUrlResponse)):
                if let responseValidationError = responseValidator.validate(httpUrlResponse) {
                    completion(responseValidationError)
                    return
                }
                
                completion(nil)
            case .failure(let urlError):
                completion(.urlError(urlError))
                return
            }
        }
    }
    
    func requestDecodableAsync<T, Request>(_ httpRequest: Request) async
    -> Result<T, APIServiceError> where T : Decodable, T == Request.DecodeType, Request : DecodableHTTPRequest {
        switch await httpClient.requestAsync(httpRequest.urlRequest) {
        case .success(let (data, httpUrlResponse)):
            if let responseValidationError = responseValidator.validate(httpUrlResponse) {
                return .failure(responseValidationError)
            }
            
            switch responseDecoder.decode(data) as Result<T, DecodingError> {
            case .success(let decoded):
                return .success(decoded)
            case .failure(let decodingError):
                return .failure(.decodingError(decodingError))
            }
        case .failure(let error):
            return .failure(APIServiceError.urlError(error))
        }
    }
    
    func requestAsync(_ httpRequest: HTTPRequest) async -> APIServiceError? {
        switch await httpClient.requestAsync(httpRequest.urlRequest) {
        case .success(let (_, httpUrlResponse)):
            if let responseValidationError = responseValidator.validate(httpUrlResponse) {
                return responseValidationError
            }
            
            return nil
        case .failure(let error):
            return APIServiceError.urlError(error)
        }
    }
}
