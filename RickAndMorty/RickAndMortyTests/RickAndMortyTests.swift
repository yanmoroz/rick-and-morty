//
//  RickAndMortyTests.swift
//  RickAndMortyTests
//
//  Created by Yan Moroz on 20.03.2024.
//

import XCTest

final class RickAndMortyTests: XCTestCase {
    enum Mocks {
        static let baseUrl = URL(string: "https://pepega.com")!
        static let decoder = JSONDecoder()
        static let decodeType = Foo.self
    }
    
    func test_returnsURLRequest() {
        let sut = makeSUT()
        XCTAssertNotNil(try? sut.urlRequest)
    }
    
    private func makeSUT() -> some Endpoint {
        EndpointImpl(baseUrl: Mocks.baseUrl, decoder: Mocks.decoder, decodeType: Mocks.decodeType)
    }
}

struct Foo: Decodable {
    
}
