//
//  au.swift
//  TastyChef
//
//  Created by Ahmed Hamza on 3/25/25.
//

import Foundation
import FirebaseAuth

class AuthenticationStateManager: ObservableObject {
    @Published var isAuthenticated = false
    static let shared = AuthenticationStateManager()
    
    private init() {
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
