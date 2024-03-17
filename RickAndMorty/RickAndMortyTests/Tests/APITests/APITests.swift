//
//  APITests.swift
//  RickAndMortyTests
//
//  Created by Yan Moroz on 15.03.2024.
//

import XCTest
@testable import RickAndMorty

final class APITests: XCTestCase {
    enum Locals {
        private static let baseAddress = "https://rickandmortyapi.com/"
        static let baseUrl = URL(string: baseAddress)!
        static let rootPath = "/api/"
        
        static let singleCharacterPath = "/api/character/2/"
        static let multipleCharactersByIdsPath = "/api/character/[1,2,3]/"
        static let multipleCharactersPath = "/api/character/"
        static let filteredCharactersQueryParameters: [String: Any] = [
            "name": "rick",
            "status": "alive"
        ]
        
        static let singleLocationPath = "/api/location/3/"
        static let multipleLocationsByIdsPath = "/api/location/[1,2,3]/"
        static let multipleLocationsPath = "/api/location/"
        static let filteredLocationsQueryParameters: [String: Any] = [
            "type": "planet"
        ]
        
        static let singleEpisodePath = "/api/episode/3/"
        static let multipleEpisodesByIdsPath = "/api/episode/[1,2,3]/"
        static let multipleEpisodesPath = "/api/episode/"
        static let filteredEpisodesQueryParameters: [String: Any] = [
            "name": "pilot"
        ]
    }
    
    private func makeSUT() -> APIService {
        APIServiceDefault(
            httpClient: HTTPClientDefault(),
            responseValidator: HTTPURLResponseValidatorDefault(),
            responseDecoder: HTTPResponseDecoderDefault()
        )
    }
    
    private func testHTTPRequest<T: Decodable>(_ httpRequest: HTTPRequestDecodableDefault<T>) {
        let apiService = makeSUT()
        let exp = XCTestExpectation()
        
        apiService.requestDecodable(httpRequest) { result in
            defer {
                exp.fulfill()
            }
            
            guard case .success = result else {
                XCTFail("Should be .success")
                return
            }
        }
        
        wait(for: exp)
    }
    
    private func testHTTPRequest<T: Decodable>(_ httpRequest: HTTPRequestDecodableDefault<T>) async {
        let apiService = makeSUT()
        
        guard case .success = await apiService.requestDecodableAsync(httpRequest) else {
            XCTFail("Should be .success")
            return
        }
    }
}

// MARK: Sync
extension APITests {
    func test_api_root_requestDecodes() {
        let configuration = HTTPRequestConfigurationDefault(baseUrl: Locals.baseUrl, path: Locals.rootPath)
        let httpRequest = HTTPRequestDecodableDefault<RickAndMortyApiRootResponse>(configuration: configuration)
        testHTTPRequest(httpRequest)
    }
    
    func test_api_singleCharacter_requestDecodes() {
        let configuration = HTTPRequestConfigurationDefault(baseUrl: Locals.baseUrl, path: Locals.singleCharacterPath)
        let httpRequest = HTTPRequestDecodableDefault<SingleCharacterResponse>(configuration: configuration)
        testHTTPRequest(httpRequest)
    }
    
    func test_api_multipleCharactersByIds_requestDecodes() {
        let configuration = HTTPRequestConfigurationDefault(baseUrl: Locals.baseUrl, path: Locals.multipleCharactersByIdsPath)
        let httpRequest = HTTPRequestDecodableDefault<MultipleCharactersByIdsResponse>(configuration: configuration)
        testHTTPRequest(httpRequest)
    }
    
    func test_api_multipleCharacters_requestDecodes() {
        let configuration = HTTPRequestConfigurationDefault(baseUrl: Locals.baseUrl, path: Locals.multipleCharactersPath)
        let httpRequest = HTTPRequestDecodableDefault<MultipleCharactersResponse>(configuration: configuration)
        testHTTPRequest(httpRequest)
    }
    
    func test_api_filteredMultipleCharacters_requestDecodes() {
        let configuration = HTTPRequestConfigurationDefault(
            baseUrl: Locals.baseUrl,
            path: Locals.multipleCharactersPath,
            queryParameters: Locals.filteredCharactersQueryParameters
        )
        let httpRequest = HTTPRequestDecodableDefault<MultipleCharactersResponse>(configuration: configuration)
        testHTTPRequest(httpRequest)
    }
    
    func test_api_singleLocation_requestDecodes() {
        let configuration = HTTPRequestConfigurationDefault(baseUrl: Locals.baseUrl, path: Locals.singleLocationPath)
        let httpRequest = HTTPRequestDecodableDefault<SingleLocationResponse>(configuration: configuration)
        testHTTPRequest(httpRequest)
    }
    
    func test_api_multipleLocationsByIds_requestDecodes() {
        let configuration = HTTPRequestConfigurationDefault(baseUrl: Locals.baseUrl, path: Locals.multipleLocationsByIdsPath)
        let httpRequest = HTTPRequestDecodableDefault<MultipleLocationsByIdsResponse>(configuration: configuration)
        testHTTPRequest(httpRequest)
    }
    
    func test_api_multipleLocations_requestDecodes() {
        let configuration = HTTPRequestConfigurationDefault(baseUrl: Locals.baseUrl, path: Locals.multipleLocationsPath)
        let httpRequest = HTTPRequestDecodableDefault<MultipleLocationsResponse>(configuration: configuration)
        testHTTPRequest(httpRequest)
    }
    
    func test_api_filteredMultipleLocations_requestDecodes() {
        let configuration = HTTPRequestConfigurationDefault(
            baseUrl: Locals.baseUrl,
            path: Locals.multipleLocationsPath,
            queryParameters: Locals.filteredLocationsQueryParameters
        )
        let httpRequest = HTTPRequestDecodableDefault<MultipleLocationsResponse>(configuration: configuration)
        testHTTPRequest(httpRequest)
    }
    
    func test_api_singleEpisode_requestDecodes() {
        let configuration = HTTPRequestConfigurationDefault(baseUrl: Locals.baseUrl, path: Locals.singleEpisodePath)
        let httpRequest = HTTPRequestDecodableDefault<SingleEpisodeResponse>(configuration: configuration)
        testHTTPRequest(httpRequest)
    }
    
    func test_api_multipleEpisodesByIds_requestDecodes() {
        let configuration = HTTPRequestConfigurationDefault(baseUrl: Locals.baseUrl, path: Locals.multipleEpisodesByIdsPath)
        let httpRequest = HTTPRequestDecodableDefault<MultipleEpisodesByIdsResponse>(configuration: configuration)
        testHTTPRequest(httpRequest)
    }
    
    func test_api_multipleEpisodes_requestDecodes() {
        let configuration = HTTPRequestConfigurationDefault(baseUrl: Locals.baseUrl, path: Locals.multipleEpisodesPath)
        let httpRequest = HTTPRequestDecodableDefault<MultipleEpisodesResponse>(configuration: configuration)
        testHTTPRequest(httpRequest)
    }
    
    func test_api_filteredMultipleEpisodes_requestDecodes() {
        let configuration = HTTPRequestConfigurationDefault(
            baseUrl: Locals.baseUrl,
            path: Locals.multipleEpisodesPath,
            queryParameters: Locals.filteredEpisodesQueryParameters
        )
        let httpRequest = HTTPRequestDecodableDefault<MultipleEpisodesResponse>(configuration: configuration)
        testHTTPRequest(httpRequest)
    }
}

// MARK: Async
extension APITests {
    func test_api_root_async_decodes() async {
        let configuration = HTTPRequestConfigurationDefault(baseUrl: Locals.baseUrl, path: Locals.rootPath)
        let httpRequest = HTTPRequestDecodableDefault<RickAndMortyApiRootResponse>(configuration: configuration)
        await testHTTPRequest(httpRequest)
    }
    
    func test_api_singleCharacter_async_requestDecodes() async {
        let configuration = HTTPRequestConfigurationDefault(baseUrl: Locals.baseUrl, path: Locals.singleCharacterPath)
        let httpRequest = HTTPRequestDecodableDefault<SingleCharacterResponse>(configuration: configuration)
        await testHTTPRequest(httpRequest)
    }
    
    func test_api_multipleCharactersByIds_async_requestDecodes() async {
        let configuration = HTTPRequestConfigurationDefault(baseUrl: Locals.baseUrl, path: Locals.multipleCharactersByIdsPath)
        let httpRequest = HTTPRequestDecodableDefault<MultipleCharactersByIdsResponse>(configuration: configuration)
        await testHTTPRequest(httpRequest)
    }
    
    func test_api_multipleCharacters_async_requestDecodes() async {
        let configuration = HTTPRequestConfigurationDefault(baseUrl: Locals.baseUrl, path: Locals.multipleCharactersPath)
        let httpRequest = HTTPRequestDecodableDefault<MultipleCharactersResponse>(configuration: configuration)
        await testHTTPRequest(httpRequest)
    }
    
    func test_api_filteredMultipleCharacters_async_requestDecodes() async {
        let configuration = HTTPRequestConfigurationDefault(
            baseUrl: Locals.baseUrl,
            path: Locals.multipleCharactersPath,
            queryParameters: Locals.filteredCharactersQueryParameters
        )
        let httpRequest = HTTPRequestDecodableDefault<MultipleCharactersResponse>(configuration: configuration)
        await testHTTPRequest(httpRequest)
    }
    
    func test_api_singleLocation_async_requestDecodes() async {
        let configuration = HTTPRequestConfigurationDefault(baseUrl: Locals.baseUrl, path: Locals.singleLocationPath)
        let httpRequest = HTTPRequestDecodableDefault<SingleLocationResponse>(configuration: configuration)
        await testHTTPRequest(httpRequest)
    }
    
    func test_api_multipleLocationsByIds_async_requestDecodes() async {
        let configuration = HTTPRequestConfigurationDefault(baseUrl: Locals.baseUrl, path: Locals.multipleLocationsByIdsPath)
        let httpRequest = HTTPRequestDecodableDefault<MultipleLocationsByIdsResponse>(configuration: configuration)
        await testHTTPRequest(httpRequest)
    }
    
    func test_api_multipleLocations_async_requestDecodes() async {
        let configuration = HTTPRequestConfigurationDefault(baseUrl: Locals.baseUrl, path: Locals.multipleLocationsPath)
        let httpRequest = HTTPRequestDecodableDefault<MultipleLocationsResponse>(configuration: configuration)
        await testHTTPRequest(httpRequest)
    }
    
    func test_api_filteredMultipleLocations_async_requestDecodes() async {
        let configuration = HTTPRequestConfigurationDefault(
            baseUrl: Locals.baseUrl,
            path: Locals.multipleLocationsPath,
            queryParameters: Locals.filteredLocationsQueryParameters
        )
        let httpRequest = HTTPRequestDecodableDefault<MultipleLocationsResponse>(configuration: configuration)
        await testHTTPRequest(httpRequest)
    }
    
    func test_api_singleEpisode_async_requestDecodes() async {
        let configuration = HTTPRequestConfigurationDefault(baseUrl: Locals.baseUrl, path: Locals.singleEpisodePath)
        let httpRequest = HTTPRequestDecodableDefault<SingleEpisodeResponse>(configuration: configuration)
        await testHTTPRequest(httpRequest)
    }
    
    func test_api_multipleEpisodesByIds_async_requestDecodes() async {
        let configuration = HTTPRequestConfigurationDefault(baseUrl: Locals.baseUrl, path: Locals.multipleEpisodesByIdsPath)
        let httpRequest = HTTPRequestDecodableDefault<MultipleEpisodesByIdsResponse>(configuration: configuration)
        await testHTTPRequest(httpRequest)
    }
    
    func test_api_multipleEpisodes_async_requestDecodes() async {
        let configuration = HTTPRequestConfigurationDefault(baseUrl: Locals.baseUrl, path: Locals.multipleEpisodesPath)
        let httpRequest = HTTPRequestDecodableDefault<MultipleEpisodesResponse>(configuration: configuration)
        await testHTTPRequest(httpRequest)
    }
    
    func test_api_filteredMultipleEpisodes_async_requestDecodes() async {
        let configuration = HTTPRequestConfigurationDefault(
            baseUrl: Locals.baseUrl,
            path: Locals.multipleEpisodesPath,
            queryParameters: Locals.filteredEpisodesQueryParameters
        )
        let httpRequest = HTTPRequestDecodableDefault<MultipleEpisodesResponse>(configuration: configuration)
        await testHTTPRequest(httpRequest)
    }
}
