//
//  HTTPClientTests.swift
//  RickAndMortyTests
//
//  Created by Yan Moroz on 22.03.2024.
//

import XCTest

final class HTTPClientTests: XCTestCase {
    enum Mocks {
        static let url = URL(string: "https://foo.bar")!
        static let urlRequest = URLRequest(url: url)
        static let notConnectedToInternetErrorCode = URLError.notConnectedToInternet
        static let httpUrlResponse = HTTPURLResponse(url: url, statusCode: 200)
        static let data = "foo".data(using: .utf8)
    }
    
    func test_httpClient_onUrlError_returnsUrlError() {
        let sut = makeSUT()
        let exp = XCTestExpectation()
        
        URLProtocolMock.requestHandler = { _ in
            (nil, nil, URLError(Mocks.notConnectedToInternetErrorCode))
        }
        
        sut.request(Mocks.urlRequest) { result in
            defer { exp.fulfill() }
            
            guard case .failure(let httpClientError) = result,
                  case .urlError = httpClientError else {
                XCTFail("Must be .urlError")
                return
            }
        }
        
        wait(for: exp)
    }
    
    func test_httpClient_onNilUrlResponse_returnsUnexpectedError() {
        let sut = makeSUT()
        let exp = XCTestExpectation()
        
        URLProtocolMock.requestHandler = { _ in
            (Mocks.data, nil, nil)
        }
        
        sut.request(Mocks.urlRequest) { result in
            defer { exp.fulfill() }
            
            guard case .failure(let httpClientError) = result,
                  case .unexpectedError = httpClientError else {
                XCTFail("Must be .unexpectedError")
                return
            }
        }
        
        wait(for: exp)
    }
    
    func test_httpClient_onDataAndHttpUrlResponseReceived_returnsSuccess() {
        let sut = makeSUT()
        let exp = XCTestExpectation()
        
        URLProtocolMock.requestHandler = { _ in
            (Mocks.data, Mocks.httpUrlResponse, nil)
        }
        
        sut.request(Mocks.urlRequest) { result in
            defer { exp.fulfill() }
            
            guard case .success = result else {
                XCTFail("Must be .success")
                return
            }
        }
        
        wait(for: exp)
    }
    
    private func makeSUT() -> HTTPClient {
        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [URLProtocolMock.self]
        let urlSession = URLSession(configuration: configuration)
        return HTTPClientImpl(urlSession: urlSession)
    }
}
