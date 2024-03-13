//
//  URLProtocolAsyncMock.swift
//  RickAndMortyTests
//
//  Created by Yan Moroz on 13.03.2024.
//

import Foundation

class URLProtocolAsyncMock: URLProtocol {
    
    static var requestHandler: ((URLRequest) throws -> (Data?, URLResponse?))?
    
    override class func canInit(with task: URLSessionTask) -> Bool {
        return true
    }
    
    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }
    
    override func startLoading() {
        guard let client else { return }
        guard let requestHandler = URLProtocolAsyncMock.requestHandler else {
            return
        }
        
        do {
            let (data, urlResponse) = try requestHandler(request)
            
            if let urlResponse {
                client.urlProtocol(self, didReceive: urlResponse, cacheStoragePolicy: .notAllowed)
            }
            
            if let data {
                client.urlProtocol(self, didLoad: data)
            }
        } catch {
            client.urlProtocol(self, didFailWithError: error)
        }
        
        client.urlProtocolDidFinishLoading(self)
    }
    
    override func stopLoading() {
        
    }
}
