//
//  DecodableAPIRequestDefault.swift
//  RickAndMortyTests
//
//  Created by Yan Moroz on 12.03.2024.
//

import Foundation

struct DecodableAPIRequestDefault<T>: DecodableAPIRequest {
    typealias DecodeTargetType = T
    
    var decoder: ResponseDecoder
    
    func urlRequest(using apiConfiguration: APIConfiguration) -> URLRequest {
        URLRequest(url: apiConfiguration.baseURL)
    }
}
