//
//  MockURLProtocol.swift
//  TastyChef
//
//  Created by Ahmed Hamza on 3/31/25.
//
import Foundation

class MockURLProtocol: URLProtocol {
    static var mockURLs = [URL?: (Data, HTTPURLResponse)]()
    
    override class func canInit(with request: URLRequest) -> Bool {
        return true
    }
    
    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }
    
    override func startLoading() {
        if let url = request.url {
            if let (data, response) = MockURLProtocol.mockURLs[url] {
                client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
                client?.urlProtocol(self, didLoad: data)
            }
        }
        
        client?.urlProtocolDidFinishLoading(self)
    }
    
    override func stopLoading() {}
} 
