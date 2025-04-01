//
//  AuthenticationStateManagerTests.swift
//  TastyChef
//
//  Created by Ahmed Hamza on 3/31/25.
//

import XCTest
@testable import TastyChef


class AuthenticationStateManagerTests: XCTestCase {
    var mockAuthStateManager: MockAuthenticationStateManager!
    
    override func setUp() {
        super.setUp()
        mockAuthStateManager = MockAuthenticationStateManager()
    }
    
    override func tearDown() {
        mockAuthStateManager = nil
        super.tearDown()
    }
    
    func testInitialState() {
        // The initial state should be unauthenticated
        XCTAssertFalse(mockAuthStateManager.isAuthenticated)
    }
    
    func testCheckForExistingUserWithNoUser() {
        // Given
        mockAuthStateManager.shouldAuthenticateOnCheck = false
        
        // When
        mockAuthStateManager.checkForExistingUser()
        
        // Then
        XCTAssertTrue(mockAuthStateManager.checkForExistingUserCalled)
        XCTAssertFalse(mockAuthStateManager.authenticateCalled)
        XCTAssertFalse(mockAuthStateManager.isAuthenticated)
    }
    
    func testCheckForExistingUserWithUser() {
        // Given
        mockAuthStateManager.shouldAuthenticateOnCheck = true
        
        // When
        mockAuthStateManager.checkForExistingUser()
        
        // Then
        XCTAssertTrue(mockAuthStateManager.checkForExistingUserCalled)
        XCTAssertTrue(mockAuthStateManager.authenticateCalled)
        XCTAssertTrue(mockAuthStateManager.isAuthenticated)
    }
    
    func testAuthenticate() {
        // Given
        XCTAssertFalse(mockAuthStateManager.isAuthenticated)
        
        // When
        mockAuthStateManager.authenticate()
        
        // Then
        XCTAssertTrue(mockAuthStateManager.authenticateCalled)
        XCTAssertTrue(mockAuthStateManager.isAuthenticated)
    }
    
    func testUnAuthenticate() {
        // Given
        mockAuthStateManager.authenticate()
        XCTAssertTrue(mockAuthStateManager.isAuthenticated)
        
        // When
        mockAuthStateManager.unAutenticate()
        
        // Then
        XCTAssertTrue(mockAuthStateManager.unAuthenticateCalled)
        XCTAssertFalse(mockAuthStateManager.isAuthenticated)
    }
    
    func testStateTransitions() {
        // Given
        XCTAssertFalse(mockAuthStateManager.isAuthenticated)
        
        // When - Authenticate
        mockAuthStateManager.authenticate()
        
        // Then
        XCTAssertTrue(mockAuthStateManager.isAuthenticated)
        
        // When - Unauthenticate
        mockAuthStateManager.unAutenticate()
        
        // Then
        XCTAssertFalse(mockAuthStateManager.isAuthenticated)
        
        // When - Authenticate again
        mockAuthStateManager.authenticate()
        
        // Then
        XCTAssertTrue(mockAuthStateManager.isAuthenticated)
    }
} 
