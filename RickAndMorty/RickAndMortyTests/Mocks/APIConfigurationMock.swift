//
//  APIConfigurationMock.swift
//  RickAndMortyTests
//
//  Created by Yan Moroz on 11.03.2024.
//

import Foundation

struct APIConfigurationMock: APIConfiguration {
    var baseURL: URL = URL(string: "https://mock.api.io")!
}
