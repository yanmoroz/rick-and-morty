//
//  APIServiceMock.swift
//  RickAndMortyTests
//
//  Created by Yan Moroz on 14.03.2024.
//

import Foundation

struct APIServiceMock: APIService {
    let httpClient: HTTPClient
    
    @discardableResult
    func requestDecodable<T, Request>(_ httpRequest: Request, completion: @escaping DecodableCompletion<T>)
    -> Cancellable where T: Decodable, Request: DecodableHTTPRequest, Request.DecodeType == T {
        httpClient.request(httpRequest.urlRequest) { result in
            switch result {
            case .success(let (data, httpUrlResponse)):
                if let responseValidationError = validateHttpUrlResponse(httpUrlResponse) {
                    completion(.failure(responseValidationError))
                    return
                }
                
                switch decode(data) as Result<T, DecodingError> {
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
                if let responseValidationError = validateHttpUrlResponse(httpUrlResponse) {
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
            if let responseValidationError = validateHttpUrlResponse(httpUrlResponse) {
                return .failure(responseValidationError)
            }
            
            switch decode(data) as Result<T, DecodingError> {
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
            if let responseValidationError = validateHttpUrlResponse(httpUrlResponse) {
                return responseValidationError
            }
            
            return nil
        case .failure(let error):
            return APIServiceError.urlError(error)
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
