//
//  RickAndMortyAPITests.swift
//  RickAndMortyTests
//
//  Created by Yan Moroz on 22.03.2024.
//

import XCTest

final class RickAndMortyAPITests: XCTestCase {
    enum Mocks {
        static let urlSession = {
            let configuration = URLSessionConfiguration.ephemeral
            return URLSession(configuration: configuration)
        }()
        static let networkService = NetworkServiceImpl(
            httpClient: HTTPClientImpl(urlSession: urlSession),
            responseValidator: HTTPURLResponseValidatorImpl()
        )
        static let apiService: APIService = APIServiceImpl(networkService: networkService)
        static let decoder = JSONDecoder.ramJsonDecoder
        static let baseUrl = URL(string: "https://rickandmortyapi.com/api/")!
    }
    
    func test_api_returnsResourcesResponse() {
        let endpoint = DecodableEndpointImpl<RAMResourcesResponse>(baseUrl: Mocks.baseUrl, decoder: Mocks.decoder)
        let exp = XCTestExpectation()
        
        Mocks.apiService.request(endpoint) { result in
            defer { exp.fulfill() }
            
            guard case .success = result else {
                XCTFail("Must be .success")
                return
            }
        }
        
        wait(for: exp)
    }
    
    func test_api_returnsCharactersResponse() {
        let endpoint = DecodableEndpointImpl<RAMCharactersResponse>(baseUrl: Mocks.baseUrl, path: "/character", decoder: Mocks.decoder)
        let exp = XCTestExpectation()
        
        Mocks.apiService.request(endpoint) { result in
            defer { exp.fulfill() }
            
            guard case .success = result else {
                XCTFail("Must be .success")
                return
            }
        }
        
        wait(for: exp)
    }
    
    func test_api_returnsLocationsResponse() {
        let endpoint = DecodableEndpointImpl<RAMLocationsResponse>(baseUrl: Mocks.baseUrl, path: "/location", decoder: Mocks.decoder)
        let exp = XCTestExpectation()
        
        Mocks.apiService.request(endpoint) { result in
            defer { exp.fulfill() }
            
            guard case .success = result else {
                XCTFail("Must be .success")
                return
            }
        }
        
        wait(for: exp)
    }
    
    func test_api_returnsEpisodesResponse() {
        let endpoint = DecodableEndpointImpl<RAMEpisodesResponse>(baseUrl: Mocks.baseUrl, path: "/episode", decoder: Mocks.decoder)
        let exp = XCTestExpectation()
        
        Mocks.apiService.request(endpoint) { result in
            defer { exp.fulfill() }
            
            guard case .success = result else {
                XCTFail("Must be .success")
                return
            }
        }
        
        wait(for: exp)
    }
    
    func test_api_returnsSingleCharacterResponse() {
        let endpoint = DecodableEndpointImpl<RAMSingleCharacterResponse>(baseUrl: Mocks.baseUrl, path: "/character/2", decoder: Mocks.decoder)
        let exp = XCTestExpectation()
        
        Mocks.apiService.request(endpoint) { result in
            defer { exp.fulfill() }
            
            guard case .success = result else {
                XCTFail("Must be .success")
                return
            }
        }
        
        wait(for: exp)
    }
    
    func test_api_returnsSingleLocationResponse() {
        let endpoint = DecodableEndpointImpl<RAMSingleLocationResponse>(baseUrl: Mocks.baseUrl, path: "/location/2", decoder: Mocks.decoder)
        let exp = XCTestExpectation()
        
        Mocks.apiService.request(endpoint) { result in
            defer { exp.fulfill() }
            
            guard case .success = result else {
                XCTFail("Must be .success")
                return
            }
        }
        
        wait(for: exp)
    }
    
    func test_api_returnsSingleEpisodeResponse() {
        let endpoint = DecodableEndpointImpl<RAMSingleEpisodeResponse>(baseUrl: Mocks.baseUrl, path: "/episode/2", decoder: Mocks.decoder)
        let exp = XCTestExpectation()
        
        Mocks.apiService.request(endpoint) { result in
            defer { exp.fulfill() }
            
            guard case .success = result else {
                XCTFail("Must be .success")
                return
            }
        }
        
        wait(for: exp)
    }
    
    func test_api_returnsMultipleCharactersResponse() {
        let endpoint = DecodableEndpointImpl<RAMMultipleCharactersResponse>(baseUrl: Mocks.baseUrl, path: "/character/[1,2,3]", decoder: Mocks.decoder)
        let exp = XCTestExpectation()
        
        Mocks.apiService.request(endpoint) { result in
            defer { exp.fulfill() }
            
            guard case .success = result else {
                XCTFail("Must be .success")
                return
            }
        }
        
        wait(for: exp)
    }
    
    func test_api_returnsMultipleLocationsResponse() {
        let endpoint = DecodableEndpointImpl<RAMMultipleLocationsResponse>(baseUrl: Mocks.baseUrl, path: "/location/[1,2,3]", decoder: Mocks.decoder)
        let exp = XCTestExpectation()
        
        Mocks.apiService.request(endpoint) { result in
            defer { exp.fulfill() }
            
            guard case .success = result else {
                XCTFail("Must be .success")
                return
            }
        }
        
        wait(for: exp)
    }
    
    func test_api_returnsMultipleEpisodesResponse() {
        let endpoint = DecodableEndpointImpl<RAMMultipleEpisodesResponse>(baseUrl: Mocks.baseUrl, path: "/episode/[1,2,3]", decoder: Mocks.decoder)
        let exp = XCTestExpectation()
        
        Mocks.apiService.request(endpoint) { result in
            defer { exp.fulfill() }
            
            guard case .success = result else {
                XCTFail("Must be .success")
                return
            }
        }
        
        wait(for: exp)
    }
}
