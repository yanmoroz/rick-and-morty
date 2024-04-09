//
//  RickAndMortyTests.swift
//  RickAndMortyTests
//
//  Created by Yan Moroz on 31.03.2024.
//

import XCTest

final class RickAndMortyTests: XCTestCase {
    
    enum Locals {
        static let networkService = NetworkServiceImpl()
        static let apiService = APIServiceImpl(
            networkService: networkService,
            decoder: JSONDecoder.ramJsonDecoder
        )
        static let rickAndMortyAPIService = RickAndMortyAPIServiceImpl(apiService: apiService)
    }
    
    func test_apiService_returnsResourcesResponse() {
        let exp = XCTestExpectation()
        
        Locals.rickAndMortyAPIService.fetchResources { result in
            defer { exp.fulfill() }
            
            switch result {
            case .success(let response):
                print(response)
            case .failure(let error):
                print(error)
                XCTFail("Should be .success")
            }
        }
        
        wait(for: [exp])
    }
    
    func test_apiService_episodesResponse() {
        let exp = XCTestExpectation()
        
        Locals.rickAndMortyAPIService.episodesResources { result in
            defer { exp.fulfill() }
            
            switch result {
            case .success(let response):
                print(response)
            case .failure(let error):
                print(error)
                XCTFail("Should be .success")
            }
        }
        
        wait(for: [exp])
    }
}
