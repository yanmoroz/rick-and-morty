//
//  RickAndMortyAPIService.swift
//  RickAndMortyTests
//
//  Created by Yan Moroz on 09.04.2024.
//

import Foundation

protocol RickAndMortyAPIService {
    func fetchResources(handler: @escaping (Result<ResourcesResponse, APIServiceError>) -> Void)
    func episodesResources(handler: @escaping (Result<EpisodesResponse, APIServiceError>) -> Void)
}

enum RickAndMortyAPI {
    case resources
    case episodes
    
    var url: URL {
        switch self {
        case .resources:
            return URL(string: "https://rickandmortyapi.com/api/")!
        case .episodes:
            return URL(string: "https://rickandmortyapi.com/api/episode/")!
        }
    }
}

class RickAndMortyAPIServiceImpl: RickAndMortyAPIService {
    let apiService: APIService
    
    init(apiService: APIService) {
        self.apiService = apiService
    }
    
    func fetchResources(handler: @escaping (Result<ResourcesResponse, APIServiceError>) -> Void) {
        let urlRequest = URLRequest(url: RickAndMortyAPI.resources.url)
        let endpoint = DecodableEndpointImpl<ResourcesResponse>(urlRequest: urlRequest)
        apiService.decodableRequest(endpoint, handler: handler)
    }
    
    func episodesResources(handler: @escaping (Result<EpisodesResponse, APIServiceError>) -> Void) {
        let urlRequest = URLRequest(url: RickAndMortyAPI.episodes.url)
        let endpoint = DecodableEndpointImpl<EpisodesResponse>(urlRequest: urlRequest)
        apiService.decodableRequest(endpoint, handler: handler)
    }
}

struct EpisodesResponse: Decodable {
    let info: PageInfo
    let results: [Episode]
    
    struct PageInfo: Decodable {
        let count: Int
        let pages: Int
        let next: URL?
        let prev: URL?
    }
    
    struct Episode: Decodable {
        let id: Int
        let name: String
        let airDate: String // Date
        let episode: String
        let characters: [URL]
        let url: URL
        let created: Date
    }
}
