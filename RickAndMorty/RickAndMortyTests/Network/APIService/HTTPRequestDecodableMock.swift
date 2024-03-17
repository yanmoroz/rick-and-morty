//
//  HTTPRequestDecodableMock.swift
//  RickAndMortyTests
//
//  Created by Yan Moroz on 14.03.2024.
//

import Foundation
@testable import RickAndMorty

class HTTPRequestDecodableMock<T: Decodable>: HTTPRequestMock, HTTPRequestDecodable {
    typealias DecodeType = T
}
