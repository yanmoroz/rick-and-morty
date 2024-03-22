//
//  APIServiceTests.swift
//  RickAndMortyTests
//
//  Created by Yan Moroz on 22.03.2024.
//

import XCTest

final class APIServiceTests: XCTestCase {
    enum Mocks {
        static let networkService = NetworkServiceImpl(
            httpClient: HTTPClientImpl(
                urlSession: {
                    let configuration = URLSessionConfiguration.ephemeral
                    configuration.protocolClasses = [URLProtocolMock.self]
                    return URLSession(configuration: configuration)
                }()
            ),
            responseValidator: HTTPURLResponseValidatorImpl()
        )
        static let url = URL(string: "https://pepe.com")!
        static let notConnectedToInternetErrorCode = URLError.notConnectedToInternet
    }
    
    func test_apiService_onNotConnectedToInternetError_returnsNetworkServiceError() {
        let sut = APIServiceImpl(networkService: Mocks.networkService)
        let endpoint = EndpointImpl(baseUrl: Mocks.url)
        let exp = XCTestExpectation()
        
        URLProtocolMock.requestHandler = { _ in
            (nil, nil, URLError(Mocks.notConnectedToInternetErrorCode))
        }
        
        sut.request(endpoint) { apiServiceError in
            defer { exp.fulfill() }
            
            guard case .networkServiceError = apiServiceError else {
                XCTFail("Must be .networkServiceError")
                return
            }
        }
        
        wait(for: exp)
    }
}

//enum APIServiceError: Error {
//    case networkServiceError(NetworkServiceError)
//    case endpointError(EndpointError)
//    case decodingError(DecodingError)
//    case unknownError(Error)
//}
