//
//  HTTPClientDefault.swift
//  RickAndMortyTests
//
//  Created by Yan Moroz on 14.03.2024.
//

import Foundation

class HTTPClientDefault: HTTPClient {
    lazy var urlSession: URLSession = {
        URLSession.shared
    }()
    
    lazy var urlSessionAsync: URLSession = {
        URLSession.shared
    }()
}
