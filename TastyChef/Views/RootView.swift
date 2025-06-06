//
//  RootView.swift
//  TastyChef
//
//  Created by Ahmed Hamza on 3/25/25.
//

import SwiftUI

struct RootView: View {
    @EnvironmentObject var authStateManager: AuthenticationStateManager

    var body: some View {
        Group {
            if authStateManager.isAuthenticated {
                TabBarView()
            } else {
                LandingPage()
            }
        }
        .onAppear {
            // Check for existing user when view appears
            authStateManager.checkForExistingUser()
        }
    }
}
#Preview {
    RootView()
}
