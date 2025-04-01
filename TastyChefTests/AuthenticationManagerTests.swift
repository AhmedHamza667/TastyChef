//
//  AuthenticationManagerTests.swift
//  TastyChef
//
//  Created by Ahmed Hamza on 3/31/25.
//

import XCTest
import FirebaseAuth
@testable import TastyChef


class AuthenticationManagerTests: XCTestCase {
    var mockAuthManager: MockAuthenticationManager!
    
    override func setUp() {
        super.setUp()
        mockAuthManager = MockAuthenticationManager()
    }
    
    override func tearDown() {
        mockAuthManager = nil
        super.tearDown()
    }
    
    func testCreateUserSuccess() async throws {
        // Given
        mockAuthManager.shouldSucceed = true
        
        // When
        let result = try await mockAuthManager.createUser(email: "test@example.com", password: "password")
        
        // Then
        XCTAssertTrue(mockAuthManager.createUserCalled)
        XCTAssertEqual(result.uid, "test-uid")
        XCTAssertEqual(result.email, "test@example.com")
        XCTAssertEqual(result.displayName, "Test User")
    }
    
    func testCreateUserFailure() async {
        // Given
        mockAuthManager.shouldSucceed = false
        
        // When & Then
        do {
            _ = try await mockAuthManager.createUser(email: "test@example.com", password: "password")
            XCTFail("Expected an error to be thrown")
        } catch {
            XCTAssertTrue(mockAuthManager.createUserCalled)
            XCTAssertEqual((error as NSError).domain, "MockAuthError")
        }
    }
    
    func testSignInSuccess() async throws {
        // Given
        mockAuthManager.shouldSucceed = true
        
        // When
        let result = try await mockAuthManager.signIn(email: "test@example.com", password: "password")
        
        // Then
        XCTAssertTrue(mockAuthManager.signInCalled)
        XCTAssertEqual(result.uid, "test-uid")
        XCTAssertEqual(result.email, "test@example.com")
    }
    
    func testSignInFailure() async {
        // Given
        mockAuthManager.shouldSucceed = false
        
        // When & Then
        do {
            _ = try await mockAuthManager.signIn(email: "test@example.com", password: "password")
            XCTFail("Expected an error to be thrown")
        } catch {
            XCTAssertTrue(mockAuthManager.signInCalled)
            XCTAssertEqual((error as NSError).domain, "MockAuthError")
        }
    }
    
    func testGetAuthenticatedUserSuccess() throws {
        // Given
        mockAuthManager.shouldSucceed = true
        
        // When
        let result = try mockAuthManager.getAuthenticatedUser()
        
        // Then
        XCTAssertTrue(mockAuthManager.getAuthenticatedUserCalled)
        XCTAssertEqual(result.uid, "test-uid")
        XCTAssertEqual(result.email, "test@example.com")
    }
    
    func testGetAuthenticatedUserFailure() {
        // Given
        mockAuthManager.shouldSucceed = false
        
        // When & Then
        do {
            _ = try mockAuthManager.getAuthenticatedUser()
            XCTFail("Expected an error to be thrown")
        } catch {
            XCTAssertTrue(mockAuthManager.getAuthenticatedUserCalled)
            XCTAssertEqual(error as? URLError, URLError(.badServerResponse))
        }
    }
    
    func testUpdateDisplayNameSuccess() async throws {
        // Given
        mockAuthManager.shouldSucceed = true
        
        // When
        try await mockAuthManager.updateDisplayName(displayName: "New Name")
        
        // Then
        XCTAssertTrue(mockAuthManager.updateDisplayNameCalled)
        XCTAssertEqual(mockAuthManager.mockUser.displayName, "New Name")
    }
    
    func testUpdateDisplayNameFailure() async {
        // Given
        mockAuthManager.shouldSucceed = false
        
        // When & Then
        do {
            try await mockAuthManager.updateDisplayName(displayName: "New Name")
            XCTFail("Expected an error to be thrown")
        } catch {
            XCTAssertTrue(mockAuthManager.updateDisplayNameCalled)
            XCTAssertEqual(error as? URLError, URLError(.badURL))
        }
    }
    
    func testSignOutSuccess() throws {
        // Given
        mockAuthManager.shouldSucceed = true
        
        // When
        try mockAuthManager.signOut()
        
        // Then
        XCTAssertTrue(mockAuthManager.signOutCalled)
    }
    
    func testSignOutFailure() {
        // Given
        mockAuthManager.shouldSucceed = false
        
        // When & Then
        do {
            try mockAuthManager.signOut()
            XCTFail("Expected an error to be thrown")
        } catch {
            XCTAssertTrue(mockAuthManager.signOutCalled)
            XCTAssertEqual((error as NSError).domain, "MockAuthError")
        }
    }
} 
