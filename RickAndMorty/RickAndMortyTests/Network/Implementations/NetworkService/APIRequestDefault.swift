//
//  APIRequestDefault.swift
//  RickAndMortyTests
//
//  Created by Yan Moroz on 11.03.2024.
//

import Foundation

struct APIRequestDefault: APIRequest {
    func urlRequest(using apiConfiguration: APIConfiguration) -> URLRequest {
        URLRequest(url: apiConfiguration.baseURL)
    }
}
