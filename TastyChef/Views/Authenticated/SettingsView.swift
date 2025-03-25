//
//  SettingsView.swift
//  TastyChef
//
//  Created by Ahmed Hamza on 3/25/25.
//

import SwiftUI

struct SettingsView: View {
    @StateObject private var vm = SettingsViewModel()
    @State private var userEmail: String = ""
    @State private var showSignOutAlert = false

    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // Profile Section
                VStack(spacing: 8) {
                    Image(systemName: "person.circle.fill")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 80, height: 80)
                        .foregroundColor(.gray)
                    
                    Text("\(userEmail)")
                        .font(.title2)
                        .fontWeight(.semibold)
                    
                    Text("15 favorite recipes")
                        .foregroundColor(.gray)
                }
                .padding(.vertical, 24)
                
                // Settings List
                VStack(spacing: 0) {
                    SettingsRowView(icon: "person.fill", iconColor: .green, title: "Edit Profile")
                    
                    Divider()
                        .padding(.leading, 56)
                    
                    SettingsRowView(icon: "bell.fill", iconColor: .green, title: "Notifications")
                    
                    Divider()
                        .padding(.leading, 56)
                    
                    SettingsRowView(icon: "lock.fill", iconColor: .green, title: "Privacy")
                }
                .background(Color(.systemBackground))
                
                Spacer()
                
                // Sign Out Button
                Button(role: .destructive) {
                    showSignOutAlert = true
                } label: {
                    Text("Sign Out")
                        .fontWeight(.semibold)
                        .foregroundColor(.red)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color(.systemGray6))
                        )
                }
                .padding(.horizontal, 24)
                .padding(.bottom, 24)
            }
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.large)
            .background(Color(.systemGray6))
            .alert("Sign Out", isPresented: $showSignOutAlert) {
                Button("Cancel", role: .cancel) { }
                Button("Sign Out", role: .destructive) {
                    vm.signOut()
                    //showLogInView = true
                }
            } message: {
                Text("Are you sure you want to sign out?")
            }
            .onAppear {
                do {
                    let authUser = try AuthenticationManager.shared.getAuthenticatedUser()
                    self.userEmail = authUser.email ?? ""
                } catch {
                    print("Error getting user: \(error)")
                }
            }
        }
    }
}

// Helper view for settings rows
struct SettingsRowView: View {
    let icon: String
    let iconColor: Color
    let title: String
    
    var body: some View {
        Button(action: {}) {
            HStack(spacing: 16) {
                Image(systemName: icon)
                    .font(.system(size: 22))
                    .foregroundColor(iconColor)
                    .frame(width: 24)
                
                Text(title)
                    .foregroundColor(.primary)
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(.gray)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
        }
        .background(Color(.systemBackground))
    }
}


#Preview {
    SettingsView()
}
