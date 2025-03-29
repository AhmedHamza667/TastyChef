//
//  SettingsView.swift
//  TastyChef
//
//  Created by Ahmed Hamza on 3/25/25.
//

import SwiftUI

struct SettingsView: View {
    @StateObject private var vm = SettingsViewModel(authManager: AuthenticationManager())
    @StateObject private var favoritesVM = FavoritesViewModel.shared
    @State private var showEditNameSheet = false
    @State private var showEmojiPicker = false
    @State private var showSignOutAlert = false
    
    var body: some View {
        NavigationStack {
            VStack {
                // Profile Section
                VStack(spacing: 12) {
                    // Profile Emoji - clickable to change
                    Button {
                        showEmojiPicker = true
                    } label: {
                        Text(vm.selectedEmoji)
                            .font(.system(size: 80))
                            .frame(width: 100, height: 100)
                            .background(Circle().fill(Color(.systemGray6)))
                    }
                    
                    // Display Name with Edit Button
                    HStack {
                        Text(vm.displayName.isEmpty ? "Add Name" : vm.displayName)
                            .font(.title2)
                            .fontWeight(.semibold)
                        
                        Button {
                            showEditNameSheet = true
                        } label: {
                            Image(systemName: "pencil")
                                .font(.system(size: 14))
                                .foregroundColor(Color("colorPrimary"))
                        }
                    }
                    
                    Text(vm.email)
                        .foregroundColor(.gray)
                    
                    Text("\(favoritesVM.favorites.count) favorite recipes")
                        .foregroundColor(.gray)
                        .padding(.top, 4)
                }
                .padding(.vertical, 24)
                
                // Settings List
                VStack(spacing: 0) {
                    SettingsRowView(icon: "person.fill", iconColor: .green, title: "Account Settings")
                    
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
            .sheet(isPresented: $showEditNameSheet) {
                EditNameView(displayName: $vm.displayName) {
                    Task {
                        await vm.updateProfileName()
                    }
                    showEditNameSheet = false
                }
            }
            .sheet(isPresented: $showEmojiPicker) {
                EmojiPickerView(selectedEmoji: $vm.selectedEmoji) {
                    Task {
                        await vm.updateProfileName()
                    }
                    showEmojiPicker = false
                }
            }
            .alert("Sign Out", isPresented: $showSignOutAlert) {
                Button("Cancel", role: .cancel) { }
                Button("Sign Out", role: .destructive) {
                    vm.signOut()
                }
            } message: {
                Text("Are you sure you want to sign out?")
            }
            .alert("Profile Updated", isPresented: $vm.showSuccess) {
                Button("OK", role: .cancel) { }
            } message: {
                Text(vm.successMessage)
            }
            .alert("Error", isPresented: $vm.showError) {
                Button("OK", role: .cancel) { }
            } message: {
                Text(vm.errorMessage ?? "An error occurred")
            }
            .overlay {
                if vm.isLoading {
                    ZStack {
                        Color.black.opacity(0.4)
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle())
                            .tint(.white)
                            .scaleEffect(1.5)
                    }
                    .ignoresSafeArea()
                }
            }
            .onAppear {
                favoritesVM.loadFavorites()
                vm.loadUserData()
            }
        }
    }
}



struct SettingsRowView: View {
    let icon: String
    let iconColor: Color
    let title: String
    
    var body: some View {
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
        .background(Color(.systemBackground))
    }
}

#Preview {
    SettingsView()
}
