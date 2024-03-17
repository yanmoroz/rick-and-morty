//
//  APIService.swift
//  RickAndMorty
//
//  Created by Yan Moroz on 18.03.2024.
//

import Foundation

protocol APIService {
    var httpClient: HTTPClient { get }
    var responseValidator: HTTPURLResponseValidator { get }
    var responseDecoder: HTTPResponseDecoder { get }
    
    typealias DecodableCompletion<T> = (Result<T, APIServiceError>) -> Void
    typealias Completion = (APIServiceError?) -> Void
    
    @discardableResult
    func requestDecodable<T, Request>(_ httpRequest: Request, completion: @escaping DecodableCompletion<T>)
    -> Cancellable where T: Decodable, Request: HTTPRequestDecodable, Request.DecodeType == T
    @discardableResult
    func request(_ httpRequest: HTTPRequest, completion: @escaping Completion) -> Cancellable
    
    func requestDecodableAsync<T, Request>(_ httpRequest: Request) async
    -> Result<T, APIServiceError> where T: Decodable, Request: HTTPRequestDecodable, Request.DecodeType == T
    func requestAsync(_ httpRequest: HTTPRequest) async -> APIServiceError?
}

extension APIService {
    @discardableResult
    func requestDecodable<T, Request>(_ httpRequest: Request, completion: @escaping DecodableCompletion<T>)
    -> Cancellable where T: Decodable, Request: HTTPRequestDecodable, Request.DecodeType == T {
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
    -> Result<T, APIServiceError> where T : Decodable, T == Request.DecodeType, Request : HTTPRequestDecodable {
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
