//
//  HTTPRequestConfigurationMock.swift
//  RickAndMortyTests
//
//  Created by Yan Moroz on 14.03.2024.
//

import Foundation

struct HTTPRequestConfigurationMock: HTTPRequestConfiguration {
    var baseUrl: URL
    var path: String? = nil
    var queryParameters: [String : Any]? = nil
}
