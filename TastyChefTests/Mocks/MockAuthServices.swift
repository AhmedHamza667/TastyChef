//
//  MockAuthServices.swift
//  TastyChef
//
//  Created by Ahmed Hamza on 3/31/25.
//

import Foundation
@testable import TastyChef

class MockAuthenticationService: AuthenticationServiceProtocol {
    var shouldSucceed = true
    var createUserCalled = false
    var signInCalled = false
    var getAuthenticatedUserCalled = false
    var updateDisplayNameCalled = false
    var signOutCalled = false
    var mockUser = AuthDataModel(uid: "test-uid", email: "test@example.com", displayName: "Test User", photoURL: nil)
    var mockError: Error = NSError(domain: "MockAuthError", code: 1, userInfo: [NSLocalizedDescriptionKey: "Mock auth error"])
    
    func createUser(email: String, password: String) async throws -> AuthDataModel {
        createUserCalled = true
        if shouldSucceed {
            return mockUser
        } else {
            throw mockError
        }
    }
    
    func signIn(email: String, password: String) async throws -> AuthDataModel {
        signInCalled = true
        if shouldSucceed {
            return mockUser
        } else {
            throw mockError
        }
    }
    
    func getAuthenticatedUser() throws -> AuthDataModel {
        getAuthenticatedUserCalled = true
        if shouldSucceed {
            return mockUser
        } else {
            throw mockError
        }
    }
    
    func updateDisplayName(displayName: String) async throws {
        updateDisplayNameCalled = true
        if shouldSucceed {
            mockUser = AuthDataModel(uid: mockUser.uid, email: mockUser.email, displayName: displayName, photoURL: mockUser.photoURL)
        } else {
            throw mockError
        }
    }
    
    func signOut() throws {
        signOutCalled = true
        if !shouldSucceed {
            throw mockError
        }
    }
}

class MockAuthenticationStateService: AuthenticationStateServiceProtocol {
    var isAuthenticated = false
    var checkForExistingUserCalled = false
    var authenticateCalled = false
    var unAuthenticateCalled = false
    
    func checkForExistingUser() {
        checkForExistingUserCalled = true
    }
    
    func authenticate() {
        authenticateCalled = true
        isAuthenticated = true
    }
    
    func unAutenticate() {
        unAuthenticateCalled = true
        isAuthenticated = false
    }
} 
