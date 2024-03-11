//
//  APIServiceMock.swift
//  RickAndMortyTests
//
//  Created by Yan Moroz on 11.03.2024.
//

import Foundation

struct APIServiceMock: APIService {    
    let networkService: NetworkService
    let errorResolver: APIServiceErrorResolver
    
    @discardableResult
    func request<T: Decodable, Request: DecodableAPIRequest>(_ request: Request, completion: @escaping Completion<T>)
    -> CancellableTask where Request.DecodeTargetType == T {
        networkService.request(request) { result in
            switch result {
            case .success(let data):
                let decodeResult = decode(data, toType: T.self, using: request.decoder)
                switch decodeResult {
                case .success(let decoded):
                    completion(.success(decoded))
                case .failure(let error):
                    completion(.failure(.decode(error)))
                }
            case .failure(let error):
                completion(.failure(errorResolver.resolve(error)))
            }
        }
    }
    
    private func decode<T: Decodable>(_ data: Data, toType: T.Type, using decoder: ResponseDecoder) -> Result<T, Error> {
        do {
            let decoded = try decoder.decode(data, toType: T.self)
            return .success(decoded)
        } catch {
            return .failure(error)
        }
    }
}
