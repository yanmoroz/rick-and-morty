//
//  URLProtocolMock.swift
//  RickAndMortyTests
//
//  Created by Yan Moroz on 10.03.2024.
//

import XCTest

class URLProtocolMock: URLProtocol {
    
    static var requestHandler: ((URLRequest) -> (Data?, HTTPURLResponse?, Error?))?
    
    override class func canInit(with request: URLRequest) -> Bool {
        true
    }
    
    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        request
    }
    
    override func startLoading() {
        guard let client else {
            XCTFail("Client is nil.")
            return
        }
        
        guard let requestHandler = Self.requestHandler else {
            XCTFail("Request Handler is nil.")
            return
        }
        
        let (data, response, error) = requestHandler(request)
        
        if let error {
            client.urlProtocol(self, didFailWithError: error)
        }
        
        if let response {
            client.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
        }
        
        if let data {
            client.urlProtocol(self, didLoad: data)
        }
        
        client.urlProtocolDidFinishLoading(self)
    }
    
    override func stopLoading() {
        
    }
}
