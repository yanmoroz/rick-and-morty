//
//  APIServiceImpl.swift
//  RickAndMortyTests
//
//  Created by Yan Moroz on 22.03.2024.
//

import Foundation

class APIServiceImpl: APIService {
    let networkService: NetworkService

    init(networkService: NetworkService) {
        self.networkService = networkService
    }

    func request(_ endpoint: Endpoint, completion: @escaping Completion) {
        let urlRequest: URLRequest
        
        do {
            urlRequest = try endpoint.urlRequest
        } catch let error as EndpointError {
            completion(APIServiceError.endpointError(error))
            return
        } catch {
            completion(APIServiceError.unknownError(error))
            return
        }
        
        networkService.request(urlRequest) { result in
            switch result {
            case .success:
                completion(nil)
            case .failure(let networkServiceError):
                completion(.networkServiceError(networkServiceError))
            }
        }
    }
    
    func request<T: Decodable, U: DecodableEndpoint>(_ endpoint: U, completion: @escaping DecodableCompletion<T>) where U.DecodeType == T {
        let urlRequest: URLRequest
        
        do {
            urlRequest = try endpoint.urlRequest
        } catch let error as EndpointError {
            completion(.failure(APIServiceError.endpointError(error)))
            return
        } catch {
            completion(.failure(APIServiceError.unknownError(error)))
            return
        }

        networkService.request(urlRequest) { [weak self] result in
            guard let self else { return }
            
            switch result {
            case .success(let data):
                let decodeResult = self.decode(T.self, from: data, using: endpoint.decoder)
                handleDecodeResult(decodeResult, completion: completion)
            case .failure(let networkServiceError):
                completion(.failure(.networkServiceError(networkServiceError)))
            }
        }
    }
    
    private func decode<T: Decodable>(_ type: T.Type, from data: Data, using decoder: JSONDecoder) -> Result<T, DecodingError> {
        do {
            let decoded = try decoder.decode(type, from: data)
            return .success(decoded)
        } catch {
            return .failure(error as! DecodingError)
        }
    }
    
    private func handleDecodeResult<T: Decodable>(_ result: Result<T, DecodingError>, completion: @escaping DecodableCompletion<T>) {
        switch result {
        case .success(let decoded):
            completion(.success(decoded))
        case .failure(let error):
            completion(.failure(.decodingError(error)))
        }
    }
}
