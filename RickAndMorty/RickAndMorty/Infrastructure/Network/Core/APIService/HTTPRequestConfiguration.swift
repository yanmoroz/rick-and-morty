//
//  HTTPRequestConfiguration.swift
//  RickAndMorty
//
//  Created by Yan Moroz on 18.03.2024.
//

import Foundation

protocol HTTPRequestConfiguration {
    var baseUrl: URL { get }
    var path: String? { get }
    var queryParameters: [String: Any]? { get }
}
