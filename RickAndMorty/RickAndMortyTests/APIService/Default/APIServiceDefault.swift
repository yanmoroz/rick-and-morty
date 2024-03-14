//
//  APIServiceDefault.swift
//  RickAndMortyTests
//
//  Created by Yan Moroz on 15.03.2024.
//

import Foundation

struct APIServiceDefault: APIService {
    let httpClient: HTTPClient
    let responseValidator: HTTPURLResponseValidator
    let responseDecoder: HTTPResponseDecoder
}
