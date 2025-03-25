//
//  SignUpView.swift
//  TastyChef
//
//  Created by Ahmed Hamza on 3/24/25.
//

import SwiftUI

struct SignUpView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject var vm = SignUpViewModel(authenticationManager: AuthenticationManager())
    var body: some View {
        NavigationStack {
            VStack(spacing: 24) {
                // Input Fields
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
                
                Button{
                    vm.createAccount()
                } label:{
                    Text("Sign Up")
                        .fontWeight(.bold)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color("colorPrimary"))
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                
                HStack(spacing: 4) {
                    Text("Already have an account?")
                        .foregroundColor(Color(.systemGray))
                    
                    NavigationLink("Log In") {
                        LogInView()
                    }
                    .foregroundColor(Color("colorPrimary"))
                }
                .frame(maxWidth: .infinity)
                
                Spacer()
            }
            .padding(.horizontal, 24)
            .padding(.top, 24)
            .navigationTitle("Create Account")
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
        }
    }
}



#Preview {
    SignUpView()
}
