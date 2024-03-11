//
//  APIServiceTests.swift
//  RickAndMortyTests
//
//  Created by Yan Moroz on 11.03.2024.
//

import XCTest

final class APIServiceTests: XCTestCase {
    
    func test_apiServiceMock_cancels() {
        let sut = makeSUT()
        let request = DecodableAPIRequestMock<DecodableMock>(decoder: ResponseDecoderMock())
        let exp = XCTestExpectation()
        
        URLProtocolMock.requestHandler = { request in
            (nil, nil, nil)
        }
        
        let task = sut.request(request) { result in
            defer {
                exp.fulfill()
            }
            
            guard case let .failure(apiServiceError) = result,
                  case let .networkService(networkServiceError) = apiServiceError,
                  case let .httpClient(urlError) = networkServiceError,
                  urlError.code == .cancelled else {
                XCTFail("Should be .cancelled")
                return
            }
        }
        
        task.cancel()
        wait(for: exp)
    }
    
    func makeSUT() -> APIService {
        return APIServiceMock(
            networkService: NetworkServiceMock(
                httpClient: HTTPClientMock(),
                apiConfiguration: APIConfigurationMock(),
                errorResolver: NetworkServiceErrorResolverMock(),
                responseValidator: URLResponseValidatorMock()
            ),
            errorResolver: APIServiceErrorResolverMock()
        )
    }
}

struct DecodableAPIRequestMock<Response>: DecodableAPIRequest {
    typealias Response = Response
    
    var decoder: ResponseDecoder
    
    func urlRequest(using apiConfiguration: APIConfiguration) -> URLRequest {
        URLRequest(url: apiConfiguration.baseURL)
    }
}

struct ResponseDecoderMock: ResponseDecoder {
    func decode<T: Decodable>(_ data: Data, toType: T.Type) throws -> T {
        try JSONDecoder().decode(T.self, from: data)
    }
}

struct DecodableMock: Decodable {
    
}
