//
//  RickAndMortyTests.swift
//  RickAndMortyTests
//
//  Created by Yan Moroz on 31.03.2024.
//

import XCTest

final class RickAndMortyTests: XCTestCase {
    func test_apiService_returnsGoogleResponse() {
        let networkService = NetworkServiceImpl()
        let apiService = APIServiceImpl(networkService: networkService)
        let urlRequest = URLRequest(url: URL(string: "https://google.com/")!)
        let endpoint = EndpointImpl(urlRequest: urlRequest)
        let exp = XCTestExpectation()
        
        apiService.request(endpoint) { error in
            defer { exp.fulfill() }
            
            guard let error else {
                return
            }
            
            print(error)
        }
        
        wait(for: [exp])
    }
    
    func test_apiService_returnsResourcesResponse() {
        let networkService = NetworkServiceImpl()
        let apiService = APIServiceImpl(networkService: networkService)
        let urlRequest = URLRequest(url: URL(string: "https://rickandmortyapi.com/api")!)
        let endpoint = DecodableEndpointImpl<ResourcesResponse>(urlRequest: urlRequest)
        let exp = XCTestExpectation()
        
        apiService.decodableRequest(endpoint) { result in
            defer { exp.fulfill() }
            
            switch result {
            case .success(let response):
                print(response)
            case .failure(let apiServiceError):
                print(apiServiceError)
            }
        }
        
        wait(for: [exp])
    }
}
