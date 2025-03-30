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
    @Published var selectedEmoji: String = "👤"
    @Published var isLoading: Bool = false
    @Published var showError: Bool = false
    @Published var errorMessage: String?
    @Published var showSuccess: Bool = false
    @Published var successMessage: String = ""
    
    // Available emoji options for profile pictures
    let emojiOptions: [String] = [
        "👤", "😀", "😎", "🤠", "👨‍🍳", "👩‍🍳", "🧑‍🍳", "🍕", "🍔", "🌮", 
        "🍰", "🍩", "🥗", "🍲", "🥑", "🍓", "🧁", "🧇", "🥞", "🍣"
    ]
    
    private var authManager: AuthenticationServiceProtocol
    
    init(authManager: AuthenticationServiceProtocol) {
        self.authManager = authManager
        loadUserData()
    }
    
    func loadUserData() {
        do {
            let user = try authManager.getAuthenticatedUser()
            self.email = user.email ?? ""
            self.displayName = user.displayName ?? ""
            
            // Extract emoji from displayName if it exists
            if let displayName = user.displayName, !displayName.isEmpty {
                // Check if the first character is an emoji from our options
                let firstChar = String(displayName.prefix(1))
                if emojiOptions.contains(firstChar) {
                    self.selectedEmoji = firstChar
                    self.displayName = String(displayName.dropFirst()).trimmingCharacters(in: .whitespacesAndNewlines)
                }
            }
        } catch {
            self.errorMessage = "Failed to load user data: \(error.localizedDescription)"
            self.showError = true
        }
    }
    
    @MainActor
    func updateProfileName() async {
        let trimmedName = displayName.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedName.isEmpty else {
            self.errorMessage = "Please enter a valid name"
            self.showError = true
            return
        }
        
        isLoading = true
        
        // Combine emoji and name for storage
        let fullDisplayName = "\(selectedEmoji) \(trimmedName)"
        
        do {
            try await authManager.updateDisplayName(displayName: fullDisplayName)
            self.successMessage = "Profile updated successfully"
            self.showSuccess = true
        } catch {
            self.errorMessage = "Failed to update profile: \(error.localizedDescription)"
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
