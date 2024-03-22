//
//  EndpointTests.swift
//  RickAndMortyTests
//
//  Created by Yan Moroz on 22.03.2024.
//

import XCTest

final class EndpointTests: XCTestCase {
    enum Mocks {
        static let baseUrl = URL(string: "https://pepega.com")!
        static let decoder = JSONDecoder()
    }
    
    func test_endpoint_returnsCorrectURL() {
        let endpoint = EndpointImpl(baseUrl: Mocks.baseUrl)
        XCTAssertEqual(endpoint.baseUrl, Mocks.baseUrl)
    }
    
    func test_decodableEndpoint_returnsCorrectURL() {
        let endpoint = DecodableEndpointImpl<DecodableStruct>(baseUrl: Mocks.baseUrl, decoder: Mocks.decoder)
        XCTAssertEqual(endpoint.baseUrl, Mocks.baseUrl)
    }
}

private struct DecodableStruct: Decodable {
    
}
