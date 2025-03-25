//
//  SettingsViewModel.swift
//  TastyChef
//
//  Created by Ahmed Hamza on 3/25/25.
//

import Foundation

class SettingsViewModel: ObservableObject {
    private let authManager: AuthenticationManager
    
    init(authenticationManager: AuthenticationManager = AuthenticationManager()) {
        self.authManager = authenticationManager
    }
    
    func signOut() {
        do {
            try authManager.signOut()
            print("Successfully signed out!")
            AuthenticationStateManager.shared.unAutenticate()
        } catch {
            print("Error signing out: \(error.localizedDescription)")
        }
    }
}
