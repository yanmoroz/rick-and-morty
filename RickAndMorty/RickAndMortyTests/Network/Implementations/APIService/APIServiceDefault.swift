//
//  APIServiceDefault.swift
//  RickAndMortyTests
//
//  Created by Yan Moroz on 12.03.2024.
//

import Foundation

struct APIServiceDefault: APIService {
    var networkService: NetworkService
    
    @discardableResult
    func request<T: Decodable, Request: DecodableAPIRequest>(_ request: Request, completion: @escaping Completion<T>)
    -> CancellableTask where T == Request.DecodeTargetType {
        networkService.request(request) { result in
            switch result {
            case .success(let data):
                let decodeResult = request.decoder.decode(data, toType: T.self)
                switch decodeResult {
                case .success(let decoded):
                    completion(.success(decoded))
                case .failure(let error):
                    completion(.failure(APIServiceError(error)))
                }
            case .failure(let networkServiceError):
                completion(.failure(APIServiceError(networkServiceError)))
            }
        }
    }
}
