//
//  XCTestCase+Extensions.swift
//  RickAndMortyTests
//
//  Created by Yan Moroz on 09.03.2024.
//

import XCTest

extension XCTestCase {
    func wait(for expectation: XCTestExpectation) {
        wait(for: [expectation])
    }
}
