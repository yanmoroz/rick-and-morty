//
//  HTTPRequest.swift
//  RickAndMorty
//
//  Created by Yan Moroz on 18.03.2024.
//

import Foundation

protocol HTTPRequest {
    var configuration: HTTPRequestConfiguration { get }
    var urlRequest: URLRequest { get }
}
