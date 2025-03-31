//
//  SecretsManagerTests
//  TastyChef
//
//  Created by Ahmed Hamza on 3/31/25.
//

import XCTest
@testable import TastyChef

class SecretsManagerTests: XCTestCase {
    var mockSecretsManager: MockSecretsManager!
    
    override func setUp() {
        super.setUp()
        
        // Create a mock secrets dictionary
        let mockSecrets: [String: Any] = [
            "API_KEY": "test-api-key",
            "API_HOST": "test-api-host",
            "BASE_URL": "https://test-url.com"
        ]
        
        mockSecretsManager = MockSecretsManager(secretsDict: mockSecrets)
    }
    
    override func tearDown() {
        mockSecretsManager = nil
        super.tearDown()
    }
    
    func testGetExistingValue() {
        // When
        let apiKey = mockSecretsManager.getValue(forKey: "API_KEY")
        
        // Then
        XCTAssertEqual(apiKey, "test-api-key")
    }
    
    func testGetExistingHost() {
        // When
        let apiHost = mockSecretsManager.getValue(forKey: "API_HOST")
        
        // Then
        XCTAssertEqual(apiHost, "test-api-host")
    }
    
    func testGetExistingURL() {
        // When
        let baseURL = mockSecretsManager.getValue(forKey: "BASE_URL")
        
        // Then
        XCTAssertEqual(baseURL, "https://test-url.com")
    }
    
    func testGetNonExistentValue() {
        // When
        let nonExistentValue = mockSecretsManager.getValue(forKey: "NON_EXISTENT_KEY")
        
        // Then
        XCTAssertNil(nonExistentValue)
    }
    
    // This is an integration test that would access the actual Secrets.plist file
    // Commented out as it would depend on the actual file existing in the test bundle
    /*
    func testActualSecretsManager() {
        // Given
        let secretsManager = SecretsManager.shared
        
        // When
        let apiKey = secretsManager.getValue(forKey: "API_KEY")
        
        // Then
        XCTAssertNotNil(apiKey)
        XCTAssertFalse(apiKey?.isEmpty ?? true)
    }
    */
} 
