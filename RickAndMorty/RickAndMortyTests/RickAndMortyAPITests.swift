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
}

struct RAMResourcesResponse: Decodable {
    let characters: URL
    let locations: URL
    let episodes: URL
}

struct RAMCharactersResponse: Decodable {
    let info: PageInfo
    let results: [RAMCharacter]
}

struct PageInfo: Decodable {
    let count: Int
    let pages: Int
    let next: FailableURL?
    let prev: FailableURL?
}

struct RAMCharacter: Decodable {
    let id: Int
    let name: String
    let status: String
    let species: String
    let type: String
    let gender: String
    let origin: RAMOrigin
    let location: RAMLocation
    let image: FailableURL
    let episode: [FailableURL]
    let url: FailableURL
    let created: Date
}

struct RAMOrigin: Decodable {
    let name: String
    let url: FailableURL
}

struct RAMLocation: Decodable {
    let name: String
    let url: FailableURL
}

struct FailableURL: Decodable {
    let url: URL?
    
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        self.url = try? container.decode(URL.self)
    }
}

