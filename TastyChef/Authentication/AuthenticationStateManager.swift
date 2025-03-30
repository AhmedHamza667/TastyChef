//
//  au.swift
//  TastyChef
//
//  Created by Ahmed Hamza on 3/25/25.
//

import Foundation
import FirebaseAuth


protocol AuthenticationStateServiceProtocol {
    var isAuthenticated: Bool { get set }
    func checkForExistingUser()
    func authenticate()
    func unAutenticate()
}

class AuthenticationStateManager: ObservableObject, AuthenticationStateServiceProtocol {
    @Published var isAuthenticated = false
    
    init() {
        // Check for existing user
        checkForExistingUser()
    }
    
    func checkForExistingUser() {
        if Auth.auth().currentUser != nil {
            authenticate()
        }
    }
    
    func authenticate() {
        print("trying to authenticate current state is \(isAuthenticated)")
        isAuthenticated = true
        print("successfully authenticated current state is \(isAuthenticated)")
    }
    
    func unAutenticate() {
        print("trying to unAuthenticate current state is \(isAuthenticated)")
        isAuthenticated = false
        print("successfully unAuthenticated current state is \(isAuthenticated)")
    }
}
