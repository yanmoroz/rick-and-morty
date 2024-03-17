//
//  HTTPRequestConfigurationDefault.swift
//  RickAndMortyTests
//
//  Created by Yan Moroz on 15.03.2024.
//

import Foundation

struct HTTPRequestConfigurationDefault: HTTPRequestConfiguration {
    var baseUrl: URL
    var path: String?
    var queryParameters: [String : Any]?
}
