//
//  NetworkManagerTests.swift
//  TastyChef
//
//  Created by Ahmed Hamza on 3/31/25.
//

import XCTest
@testable import TastyChef


class NetworkManagerTests: XCTestCase {
    var networkManager: NetworkManager!
    var mockSession: URLSession!
    
    override func setUp() {
        super.setUp()
        
        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [MockURLProtocol.self]
        mockSession = URLSession(configuration: configuration)
        networkManager = NetworkManager(urlSession: mockSession)
    }
    
    override func tearDown() {
        mockSession = nil
        networkManager = nil
        MockURLProtocol.mockURLs.removeAll()
        super.tearDown()
    }
    
    func testGetDataFromWebServiceSuccess() async throws {
        // Given
        struct TestModel: Codable, Equatable {
            let name: String
            let id: Int
        }
        
        let testModel = TestModel(name: "Test Recipe", id: 123)
        let testData = try JSONEncoder().encode(testModel)
        
        let url = URL(string: "https://api.example.com/test")!
        let response = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil)!
        
        MockURLProtocol.mockURLs[url] = (testData, response)
        
        // When
        let result = try await networkManager.getDataFromWebService(url: url, modelType: TestModel.self)
        
        // Then
        XCTAssertEqual(result.name, "Test Recipe")
        XCTAssertEqual(result.id, 123)
    }
    
    func testGetDataFromWebServiceInvalidURL() async {
        // Given
        struct TestModel: Codable {
            let name: String
        }
        
        // When
        do {
            let _: TestModel = try await networkManager.getDataFromWebService(url: nil, modelType: TestModel.self)
            XCTFail("Expected to throw an error")
        } catch {
            // Then
            XCTAssertEqual(error as? WebServiceError, WebServiceError.invalidURL)
        }
    }
    
    func testGetDataFromWebServiceInvalidResponse() async {
        // Given
        struct TestModel: Codable {
            let name: String
        }
        
        let testData = Data("{\"name\": \"Test\"}".utf8)
        let url = URL(string: "https://api.example.com/test")!
        let response = HTTPURLResponse(url: url, statusCode: 404, httpVersion: nil, headerFields: nil)!
        
        MockURLProtocol.mockURLs[url] = (testData, response)
        
        // When
        do {
            let _: TestModel = try await networkManager.getDataFromWebService(url: url, modelType: TestModel.self)
            XCTFail("Expected to throw an error")
        } catch {
            // Then
            XCTAssertEqual(error as? WebServiceError, WebServiceError.invalidResponse(404))
        }
    }
} 
