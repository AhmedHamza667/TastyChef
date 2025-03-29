//
//  au.swift
//  TastyChef
//
//  Created by Ahmed Hamza on 3/25/25.
//

import Foundation

 class AuthenticationStateManager: ObservableObject {
    @Published var isAuthenticated = false
    static let shared = AuthenticationStateManager()
    
    private init() {}
    
    func authenticate() {
//        print("trying to authinticate current state is \(isAuthenticated)")
        isAuthenticated = true
//        print("successfully authenticated current state is \(isAuthenticated)")
    }
    
    func unAutenticate() {
//        print("trying to unAuthinticate current state is \(isAuthenticated)")
        isAuthenticated = false
//        print("successfully unAuthenticated current state is \(isAuthenticated)")
    }
}
