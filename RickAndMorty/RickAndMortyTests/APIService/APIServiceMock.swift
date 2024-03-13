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
    func request<T, Request>(_ httpRequest: Request, completion: @escaping DecodableCompletion<T>)
    -> Cancellable where T: Decodable, Request: DecodableHTTPRequest, Request.DecodeType == T {
        httpClient.request(httpRequest.urlRequest) { data, urlResponse, error in
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
    func request(_ httpRequest: HTTPRequest, completion: @escaping Completion) -> Cancellable {
        httpClient.request(httpRequest.urlRequest) { data, urlResponse, error in
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
