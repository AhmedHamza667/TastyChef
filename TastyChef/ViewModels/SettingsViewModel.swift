//
//  SettingsViewModel.swift
//  TastyChef
//
//  Created by Ahmed Hamza on 3/25/25.
//

import Foundation
import SwiftUI
import Combine

class SettingsViewModel: ObservableObject {
    @Published var displayName: String = ""
    @Published var email: String = ""
    @Published var isLoading: Bool = false
    @Published var showError: Bool = false
    @Published var errorMessage: String?
    @Published var showSuccess: Bool = false
    @Published var successMessage: String = ""
    
    private var authManager: AuthenticationManager
    
    init(authManager: AuthenticationManager) {
        self.authManager = authManager
        loadUserData()
    }
    
    func loadUserData() {
        do {
            let user = try authManager.getAuthenticatedUser()
            self.email = user.email ?? ""
            self.displayName = user.displayName ?? ""
        } catch {
            self.errorMessage = "Failed to load user data: \(error.localizedDescription)"
            self.showError = true
        }
    }
    
    @MainActor
    func updateProfileName() async {
        guard !displayName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            self.errorMessage = "Please enter a valid name"
            self.showError = true
            return
        }
        
        isLoading = true
        
        do {
            try await authManager.updateDisplayName(displayName: displayName)
            self.successMessage = "Display name updated successfully"
            self.showSuccess = true
        } catch {
            self.errorMessage = "Failed to update display name: \(error.localizedDescription)"
            self.showError = true
        }
        
        isLoading = false
    }
    
    func signOut() {
        do {
            try authManager.signOut()
            AuthenticationStateManager.shared.unAutenticate()
        } catch {
            self.errorMessage = "Failed to sign out: \(error.localizedDescription)"
            self.showError = true
        }
    }
}
