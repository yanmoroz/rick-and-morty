//
//  APIServiceDefault.swift
//  RickAndMortyTests
//
//  Created by Yan Moroz on 12.03.2024.
//

import Foundation

struct APIServiceDefault: APIService {
    var networkService: NetworkService
    
    func request<T: Decodable, Request: DecodableAPIRequest>(_ request: Request, completion: @escaping Completion<T>)
    -> CancellableTask where T == Request.DecodeTargetType {
        networkService.request(request) { result in
            
        }
    }
}
