//
//  LogInViewModel.swift
//  TastyChef
//
//  Created by Ahmed Hamza on 3/24/25.
//


import Foundation


final class LogInViewModel: ObservableObject{
    @Published var email: String = ""
    @Published var password: String = ""
    private var authenticationManager: AuthenticationManager
    
    init(authenticationManager: AuthenticationManager) {
        self.authenticationManager = authenticationManager
    }
    private let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
    
    func isValid(email: String, password: String) -> Bool {
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        let isEmailValid = emailPredicate.evaluate(with: email)
        
        let isPasswordValid = password.count >= 6
        
        return isEmailValid && isPasswordValid
    }
    
        
    func logIn(){
        guard isValid(email: email, password: password) else {
            print("Email or password is not valid")
            return
        }
        Task{
            do{
                let returnedUserData = try await authenticationManager.signIn(email: email, password: password)
                print("Successfully signed in user with email: \(returnedUserData)")
                await MainActor.run {
                    AuthenticationStateManager.shared.authenticate()
                }
            } catch{
                print("Error logging in user: \(error.localizedDescription)")
            }
        }
    }
    
  
}
