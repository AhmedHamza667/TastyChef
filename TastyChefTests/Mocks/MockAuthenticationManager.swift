//
//  MockAuthenticationManager.swift
//  TastyChef
//
//  Created by Ahmed Hamza on 3/31/25.
//

import Foundation
@testable import TastyChef

class MockAuthenticationManager: AuthenticationServiceProtocol {
    var shouldSucceed = true
    var mockUser: AuthDataModel = AuthDataModel(uid: "test-uid", email: "test@example.com", displayName: "Test User", photoURL: nil)
    var createUserCalled = false
    var signInCalled = false
    var getAuthenticatedUserCalled = false
    var updateDisplayNameCalled = false
    var signOutCalled = false
    
    func createUser(email: String, password: String) async throws -> AuthDataModel {
        createUserCalled = true
        if shouldSucceed {
            return mockUser
        } else {
            throw NSError(domain: "MockAuthError", code: 1, userInfo: [NSLocalizedDescriptionKey: "Mock auth error"])
        }
    }
    
    func signIn(email: String, password: String) async throws -> AuthDataModel {
        signInCalled = true
        if shouldSucceed {
            return mockUser
        } else {
            throw NSError(domain: "MockAuthError", code: 1, userInfo: [NSLocalizedDescriptionKey: "Mock auth error"])
        }
    }
    
    func getAuthenticatedUser() throws -> AuthDataModel {
        getAuthenticatedUserCalled = true
        if shouldSucceed {
            return mockUser
        } else {
            throw URLError(.badServerResponse)
        }
    }
    
    func updateDisplayName(displayName: String) async throws {
        updateDisplayNameCalled = true
        if shouldSucceed {
            mockUser = AuthDataModel(uid: mockUser.uid, email: mockUser.email, displayName: displayName, photoURL: mockUser.photoURL)
        } else {
            throw URLError(.badURL)
        }
    }
    
    func signOut() throws {
        signOutCalled = true
        if !shouldSucceed {
            throw NSError(domain: "MockAuthError", code: 1, userInfo: [NSLocalizedDescriptionKey: "Mock sign out error"])
        }
    }
} 
