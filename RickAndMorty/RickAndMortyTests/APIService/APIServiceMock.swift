//
//  APIServiceMock.swift
//  RickAndMortyTests
//
//  Created by Yan Moroz on 14.03.2024.
//

import Foundation
@testable import RickAndMorty

struct APIServiceMock: APIService {
    let httpClient: HTTPClient
    let responseValidator: HTTPURLResponseValidator
    let responseDecoder: HTTPResponseDecoder
}
