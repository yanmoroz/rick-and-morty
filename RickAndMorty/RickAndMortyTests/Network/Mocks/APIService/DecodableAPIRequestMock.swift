//
//  DecodableAPIRequestMock.swift
//  RickAndMortyTests
//
//  Created by Yan Moroz on 11.03.2024.
//

import Foundation

struct DecodableAPIRequestMock<DecodeTargetType>: DecodableAPIRequest {
    typealias DecodeTargetType = DecodeTargetType
    
    var decoder: ResponseDecoder
    
    func urlRequest(using apiConfiguration: APIConfiguration) -> URLRequest {
        URLRequest(url: apiConfiguration.baseURL)
    }
}
