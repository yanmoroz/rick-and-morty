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
        static let decoder = JSONDecoder()
        static let data = "foo".data(using: .utf8)
        static let validHttpUrlResponse = HTTPURLResponse(url: url, statusCode: 200)!
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
    
    func test_apiService_onBadData_returnsDecodingError() {
        let sut = APIServiceImpl(networkService: Mocks.networkService)
        let endpoint = DecodableEndpointImpl<DecodableStruct>(baseUrl: Mocks.url, decoder: Mocks.decoder)
        let exp = XCTestExpectation()
        
        URLProtocolMock.requestHandler = { _ in
            (Mocks.data, Mocks.validHttpUrlResponse, nil)
        }
        
        sut.request(endpoint) { result in
            defer { exp.fulfill() }
            
            guard case .failure(let apiServiceError) = result,
                  case .decodingError = apiServiceError
            else {
                XCTFail("Must be .decodingError")
                return
            }
        }
        
        wait(for: exp)
    }
}

private struct DecodableStruct: Decodable {
    let id: Int
}
