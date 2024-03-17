//
//  HTTPRequestDecodableDefault.swift
//  RickAndMortyTests
//
//  Created by Yan Moroz on 15.03.2024.
//

import Foundation

class HTTPRequestDecodableDefault<T: Decodable>: HTTPRequestDefault, HTTPRequestDecodable {
    typealias DecodeType = T
}
