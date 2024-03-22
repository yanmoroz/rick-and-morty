//
//  EndpointImpl.swift
//  RickAndMortyTests
//
//  Created by Yan Moroz on 22.03.2024.
//

import Foundation

struct EndpointImpl<DecodeType: Decodable>: Endpoint {    
    let baseUrl: URL
    let decoder: JSONDecoder
    let decodeType: DecodeType.Type
    
    var urlRequest: URLRequest {
        get throws {
            guard let components = URLComponents(string: baseUrl.absoluteString),
                  let url = components.url
            else {
                throw EndpointError.badUrl
            }
            
            return URLRequest(url: url)
        }
    }
}
