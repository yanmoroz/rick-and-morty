//
//  URLProtocolMock.swift
//  RickAndMortyTests
//
//  Created by Yan Moroz on 21.03.2024.
//

import Foundation

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
