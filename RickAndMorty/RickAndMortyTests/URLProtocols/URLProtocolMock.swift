//
//  URLProtocolMock.swift
//  RickAndMortyTests
//
//  Created by Yan Moroz on 13.03.2024.
//

import Foundation

class URLProtocolMock: URLProtocol {
    
    static var requestHandler: ((URLRequest) -> (Data?, URLResponse?, Error?))?
    
    override class func canInit(with task: URLSessionTask) -> Bool {
        return true
    }
    
    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }
    
    override func startLoading() {
        guard let client else { return }
        guard let requestHandler = URLProtocolMock.requestHandler else {
            return
        }
        
        let (data, urlResponse, error) = requestHandler(request)
        
        if let error {
            client.urlProtocol(self, didFailWithError: error)
        }
        
        if let urlResponse {
            client.urlProtocol(self, didReceive: urlResponse, cacheStoragePolicy: .notAllowed)
        }
        
        if let data {
            client.urlProtocol(self, didLoad: data)
        }
        
        client.urlProtocolDidFinishLoading(self)
    }
    
    override func stopLoading() {
        
    }
}
