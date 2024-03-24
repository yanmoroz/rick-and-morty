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
        let endpoint = DecodableEndpointImpl<RAMCharactersResponse>(
            baseUrl: Mocks.baseUrl,
            path: "/character",
            decoder: Mocks.decoder
        )
        let exp = XCTestExpectation()
        
        Mocks.apiService.request(endpoint) { result in
            defer { exp.fulfill() }
            
            guard case .success(let response) = result,
                  response.results.count > 0
            else {
                XCTFail("Must be .success")
                return
            }
        }
        
        wait(for: exp)
    }
    
    func test_api_returnsLocationsResponse() {
        let endpoint = DecodableEndpointImpl<RAMLocationsResponse>(
            baseUrl: Mocks.baseUrl,
            path: "/location",
            decoder: Mocks.decoder
        )
        let exp = XCTestExpectation()
        
        Mocks.apiService.request(endpoint) { result in
            defer { exp.fulfill() }
            
            guard case .success(let response) = result,
                  response.results.count > 0
            else {
                XCTFail("Must be .success")
                return
            }
        }
        
        wait(for: exp)
    }
    
    func test_api_returnsEpisodesResponse() {
        let endpoint = DecodableEndpointImpl<RAMEpisodesResponse>(
            baseUrl: Mocks.baseUrl,
            path: "/episode",
            decoder: Mocks.decoder
        )
        let exp = XCTestExpectation()
        
        Mocks.apiService.request(endpoint) { result in
            defer { exp.fulfill() }
            
            guard case .success(let response) = result,
                  response.results.count > 0
            else {
                XCTFail("Must be .success")
                return
            }
        }
        
        wait(for: exp)
    }
    
    func test_api_returnsSingleCharacterResponse() {
        let characterId = 2
        let endpoint = DecodableEndpointImpl<RAMSingleCharacterResponse>(
            baseUrl: Mocks.baseUrl,
            path: "/character/\(characterId)",
            decoder: Mocks.decoder
        )
        let exp = XCTestExpectation()
        
        Mocks.apiService.request(endpoint) { result in
            defer { exp.fulfill() }
            
            guard case .success(let response) = result,
                  response.character.id == characterId
            else {
                XCTFail("Must be .success")
                return
            }
        }
        
        wait(for: exp)
    }
    
    func test_api_returnsSingleLocationResponse() {
        let locationId = 2
        let endpoint = DecodableEndpointImpl<RAMSingleLocationResponse>(
            baseUrl: Mocks.baseUrl,
            path: "/location/\(locationId)",
            decoder: Mocks.decoder
        )
        let exp = XCTestExpectation()
        
        Mocks.apiService.request(endpoint) { result in
            defer { exp.fulfill() }
            
            guard case .success(let response) = result,
                  response.location.id == locationId
            else {
                XCTFail("Must be .success")
                return
            }
        }
        
        wait(for: exp)
    }
    
    func test_api_returnsSingleEpisodeResponse() {
        let episodeId = 2
        let endpoint = DecodableEndpointImpl<RAMSingleEpisodeResponse>(
            baseUrl: Mocks.baseUrl,
            path: "/episode/\(episodeId)",
            decoder: Mocks.decoder
        )
        let exp = XCTestExpectation()
        
        Mocks.apiService.request(endpoint) { result in
            defer { exp.fulfill() }
            
            guard case .success(let response) = result,
                  response.episode.id == episodeId
            else {
                XCTFail("Must be .success")
                return
            }
        }
        
        wait(for: exp)
    }
    
    func test_api_returnsMultipleCharactersResponse() {
        let characterIds = [1,2,3]
        let characterIdsAsStrings = characterIds.map({ String($0) }).joined(separator: ",")
        let endpoint = DecodableEndpointImpl<RAMMultipleCharactersResponse>(
            baseUrl: Mocks.baseUrl,
            path: "/character/[\(characterIdsAsStrings)]",
            decoder: Mocks.decoder
        )
        let exp = XCTestExpectation()
        
        Mocks.apiService.request(endpoint) { result in
            defer { exp.fulfill() }
            
            guard case .success(let response) = result,
                  response.characters.map({ $0.id }) == characterIds
            else {
                XCTFail("Must be .success")
                return
            }
        }
        
        wait(for: exp)
    }
    
    func test_api_returnsMultipleLocationsResponse() {
        let locationIds = [1,2,3]
        let locationIdsAsStrings = locationIds.map({ String($0) }).joined(separator: ",")
        let endpoint = DecodableEndpointImpl<RAMMultipleLocationsResponse>(
            baseUrl: Mocks.baseUrl,
            path: "/location/\(locationIdsAsStrings)",
            decoder: Mocks.decoder
        )
        let exp = XCTestExpectation()
        
        Mocks.apiService.request(endpoint) { result in
            defer { exp.fulfill() }
            
            guard case .success(let response) = result,
                  response.locations.map({ $0.id }) == locationIds
            else {
                XCTFail("Must be .success")
                return
            }
        }
        
        wait(for: exp)
    }
    
    func test_api_returnsMultipleEpisodesResponse() {
        let episodeIds = [1,2,3]
        let episodeIdsAsStrings = episodeIds.map({ String($0) }).joined(separator: ",")
        let endpoint = DecodableEndpointImpl<RAMMultipleEpisodesResponse>(
            baseUrl: Mocks.baseUrl,
            path: "/episode/\(episodeIdsAsStrings)",
            decoder: Mocks.decoder
        )
        let exp = XCTestExpectation()
        
        Mocks.apiService.request(endpoint) { result in
            defer { exp.fulfill() }
            
            guard case .success(let response) = result,
                  response.episodes.map({ $0.id }) == episodeIds
            else {
                XCTFail("Must be .success")
                return
            }
        }
        
        wait(for: exp)
    }
    
    func test_api_returnsFilteredCharactersResponse() {
        let endpoint = DecodableEndpointImpl<RAMCharactersResponse>(
            baseUrl: Mocks.baseUrl,
            path: "/character",
            queryParameters: [
                "name": "rick",
                "status": "alive"
            ],
            decoder: Mocks.decoder
        )
        let exp = XCTestExpectation()
        
        Mocks.apiService.request(endpoint) { result in
            defer { exp.fulfill() }
            
            guard case .success(let response) = result,
                  response.results.allSatisfy({
                      $0.name.lowercased().contains("rick") && $0.status.lowercased() == "alive"
                  })
            else {
                XCTFail("Must be .success")
                return
            }
        }
        
        wait(for: exp)
    }
    
    func test_api_returnsFilteredLocationsResponse() {
        let endpoint = DecodableEndpointImpl<RAMLocationsResponse>(
            baseUrl: Mocks.baseUrl,
            path: "/location",
            queryParameters: [
                "type": "planet"
            ],
            decoder: Mocks.decoder
        )
        let exp = XCTestExpectation()
        
        Mocks.apiService.request(endpoint) { result in
            defer { exp.fulfill() }
            
            guard case .success(let response) = result,
                  response.results.allSatisfy({ $0.type.lowercased() == "planet" })
            else {
                XCTFail("Must be .success")
                return
            }
        }
        
        wait(for: exp)
    }
    
    func test_api_returnsFilteredEpisodesResponse() {
        let endpoint = DecodableEndpointImpl<RAMEpisodesResponse>(
            baseUrl: Mocks.baseUrl,
            path: "/episode",
            queryParameters: [
                "name": "pilot"
            ],
            decoder: Mocks.decoder
        )
        let exp = XCTestExpectation()
        
        Mocks.apiService.request(endpoint) { result in
            defer { exp.fulfill() }
            
            guard case .success(let response) = result,
                  response.results.allSatisfy({ $0.name.lowercased().contains("pilot") })
            else {
                XCTFail("Must be .success")
                return
            }
        }
        
        wait(for: exp)
    }
}
