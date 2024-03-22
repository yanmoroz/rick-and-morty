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
        static let decoder = JSONDecoder()
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
}

struct RAMResourcesResponse: Decodable {
    let characters: URL
    let locations: URL
    let episodes: URL
}
