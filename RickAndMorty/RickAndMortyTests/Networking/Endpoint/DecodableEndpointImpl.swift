//
//  DecodableEndpointImpl.swift
//  RickAndMortyTests
//
//  Created by Yan Moroz on 22.03.2024.
//

import Foundation

struct DecodableEndpointImpl<DecodeType: Decodable>: DecodableEndpoint {    
    var baseUrl: URL
    var path: String? = nil
    var decoder: JSONDecoder
}
