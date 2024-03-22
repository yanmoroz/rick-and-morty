//
//  HTTPURLResponseValidatorTests.swift
//  RickAndMortyTests
//
//  Created by Yan Moroz on 22.03.2024.
//

import XCTest

final class HTTPURLResponseValidatorTests: XCTestCase {
    enum Mocks {
        private static let url = URL(string: "https://pepega.com")!
        static let validHttpUrlResponse = HTTPURLResponse(url: url, statusCode: 200)!
        static let invalidHttpUrlResponse = HTTPURLResponse(url: url, statusCode: 404)!
    }
    
    func test_onValidResponse_returnsNilError() {
        let sut = makeSUT()
        XCTAssertNil(sut.validate(Mocks.validHttpUrlResponse))
    }
    
    func test_onInvalidResponse_returnsError() {
        let sut = makeSUT()
        XCTAssertNotNil(sut.validate(Mocks.invalidHttpUrlResponse))
    }
    
    private func makeSUT() -> HTTPURLResponseValidator {
        HTTPURLResponseValidatorImpl()
    }
}
