//
//  LoginView.swift
//  TastyChef
//
//  Created by Ahmed Hamza on 3/24/25.
//

import SwiftUI

struct LogInView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject var vm = AuthenticationViewModel(authenticationManager: AuthenticationManager(), authenticationStateManager: AuthenticationStateManager())
    var body: some View {
        NavigationStack {
            VStack(spacing: 24) {
                VStack(spacing: 16) {
                    TextField("Email", text: $vm.email)
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(12)                       .keyboardType(.emailAddress)
                        .autocapitalization(.none)
                        .autocorrectionDisabled()
                    
                    SecureField("Password", text: $vm.password)
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(12)
                }
                
                Button {
                    vm.logIn()
                } label: {
                    HStack {
                        if vm.isLoading {
                            ProgressView()
                                .tint(.white)
                        } else {
                            Text("Log In")
                        }
                    }
                    .fontWeight(.bold)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color("colorPrimary").opacity(vm.isFormValid ? 1.0 : 0.5))
                    .foregroundColor(.white)
                    .cornerRadius(10)
                }
                .disabled(!vm.isFormValid || vm.isLoading)
                
                HStack(spacing: 4) {
                    Text("Don't have an account?")
                        .foregroundColor(Color(.systemGray))
                    
                    NavigationLink("Sign Up") {
                        SignUpView()
                    }
                    .foregroundColor(Color("colorPrimary"))
                }
                .frame(maxWidth: .infinity)
                
                Spacer()
            }
            .padding(.horizontal, 24)
            .padding(.top, 24)
            .navigationTitle("Log In")
            .navigationBarTitleDisplayMode(.large)
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        dismiss()
                    }) {
                        Image(systemName: "arrow.left")
                            .foregroundColor(.black)
                            .font(.system(size: 18, weight: .semibold))
                    }
                }
            }
            .alert("Error", isPresented: $vm.showError) {
                Button("OK") {
                    vm.error = nil
                }
            } message: {
                Text(vm.error ?? "An unknown error occurred")
            }
            .disabled(vm.isLoading)
        
        }
    }
}



#Preview {
    LogInView()
}
