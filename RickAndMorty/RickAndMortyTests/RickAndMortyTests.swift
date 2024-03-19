//
//  RickAndMortyTests.swift
//  RickAndMortyTests
//
//  Created by Yan Moroz on 20.03.2024.
//

import XCTest

final class RickAndMortyTests: XCTestCase {
    
    enum Mocks {
        static let url = URL(string: "https://foo.bar")!
        static let urlRequest = URLRequest(url: url)
        static let notConnectedToInternetErrorCode = URLError.notConnectedToInternet
        static let httpUrlResponse = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil)
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
            ("foo".data(using: .utf8), nil, nil)
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
    
    func test_httpClient_onDataAndHTTPUrlResponseReceived_returnsSuccess() {
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
    
    func test_() {
        
    }
    
    private func makeSUT() -> HTTPClient {
        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [URLProtocolMock.self]
        let urlSession = URLSession(configuration: configuration)
        return HTTPClientImpl(urlSession: urlSession)
    }
}

enum HTTPClientError: Error {
    case urlError(URLError)
    case unexpectedError
}

protocol HTTPClient {
    typealias Completion = (Result<(Data, HTTPURLResponse), HTTPClientError>) -> Void
    func request(_ urlRequest: URLRequest, completion: @escaping Completion)
}

class HTTPClientImpl: HTTPClient {
    let urlSession: URLSession
    
    init(urlSession: URLSession = URLSession.shared) {
        self.urlSession = urlSession
    }
    
    func request(_ urlRequest: URLRequest, completion: @escaping Completion) {
        let task = urlSession.dataTask(with: urlRequest) { data, urlResponse, error in
            if let urlError = error as? URLError {
                completion(.failure(.urlError(urlError)))
                return
            }
            
            guard let data, let httpUrlResponse = urlResponse as? HTTPURLResponse else {
                completion(.failure(.unexpectedError))
                return
            }
            
            completion(.success((data, httpUrlResponse)))
        }
        
        task.resume()
    }
}

class URLProtocolMock: URLProtocol {
    
    static var requestHandler: ((URLRequest) -> (Data?, HTTPURLResponse?, URLError?))?
    
    override class func canInit(with task: URLSessionTask) -> Bool {
        true
    }
    
    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        request
    }
    
    override func startLoading() {
        guard let client,
              let requestHandler = Self.requestHandler else {
            return
        }
        
        let (data, httpUrlResponse, urlError) = requestHandler(request)
        
        if let urlError {
            client.urlProtocol(self, didFailWithError: urlError)
        }
        
        if let httpUrlResponse {
            client.urlProtocol(self, didReceive: httpUrlResponse, cacheStoragePolicy: .notAllowed)
        }
        
        if let data {
            client.urlProtocol(self, didLoad: data)
        }
        
        client.urlProtocolDidFinishLoading(self)
    }
    
    override func stopLoading() {
        
    }
}



enum NetworkServiceError: Error {
    case httpClientError(HTTPClientError)
    case httpUrlResponseValidatorError(HTTPURLResponseValidatorError)
}

protocol NetworkService {
    typealias Completion = (Result<Data, NetworkServiceError>) -> Void
    func request(_ urlRequest: URLRequest, completion: @escaping Completion)
}

class NetworkServiceImpl: NetworkService {
    let httpClient: HTTPClient
    let responseValidator: HTTPURLResponseValidator
    
    init(httpClient: HTTPClient, responseValidator: HTTPURLResponseValidator) {
        self.httpClient = httpClient
        self.responseValidator = responseValidator
    }
    
    func request(_ urlRequest: URLRequest, completion: @escaping Completion) {
        httpClient.request(urlRequest) { [weak self] result in
            guard let self else { return }
            
            switch result {
            case .success(let (data, httpUrlResponse)):
                handleSuccess(data: data, httpUrlResponse: httpUrlResponse, completion: completion)
            case .failure(let httpClientError):
                completion(.failure(.httpClientError(httpClientError)))
            }
        }
    }
    
    private func handleSuccess(data: Data, httpUrlResponse: HTTPURLResponse, completion: @escaping Completion) {
        guard let validationError = self.responseValidator.validate(httpUrlResponse) else {
            completion(.success(data))
            return
        }
        
        completion(.failure(.httpUrlResponseValidatorError(validationError)))
    }
}

enum HTTPURLResponseValidatorError: Error {
    case statusCode(Int)
}

protocol HTTPURLResponseValidator {
    func validate(_ httpUrlResponse: HTTPURLResponse) -> HTTPURLResponseValidatorError?
}

class HTTPURLResponseValidatorImpl: HTTPURLResponseValidator {
    func validate(_ httpUrlResponse: HTTPURLResponse) -> HTTPURLResponseValidatorError? {
        guard (200..<300).contains(httpUrlResponse.statusCode) else {
            return .statusCode(httpUrlResponse.statusCode)
        }
        
        return nil
    }
}
