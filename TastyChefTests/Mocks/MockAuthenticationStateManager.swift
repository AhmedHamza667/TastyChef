//
//  MockAuthenticationStateManager.swift
//  TastyChef
//
//  Created by Ahmed Hamza on 3/31/25.
//

import Foundation
@testable import TastyChef

class MockAuthenticationStateManager: AuthenticationStateServiceProtocol {
    var isAuthenticated = false
    var checkForExistingUserCalled = false
    var authenticateCalled = false
    var unAuthenticateCalled = false
    var shouldAuthenticateOnCheck = false
    
    func checkForExistingUser() {
        checkForExistingUserCalled = true
        if shouldAuthenticateOnCheck {
            authenticate()
        }
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
