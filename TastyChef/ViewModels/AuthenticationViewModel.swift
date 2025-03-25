//
//  LogInViewModel.swift
//  TastyChef
//
//  Created by Ahmed Hamza on 3/24/25.
//


import Foundation
import Combine

final class AuthenticationViewModel: ObservableObject{
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var isFormValid = false

    private var authenticationManager: AuthenticationManager
    private var cancellables = Set<AnyCancellable>()

    init(authenticationManager: AuthenticationManager) {
        self.authenticationManager = authenticationManager
        setupValidation()
    }
    private let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
    
    // publisher to keep checking if form valid
    private func setupValidation() {
        Publishers.CombineLatest($email, $password)
            .debounce(for: 0.5, scheduler: DispatchQueue.main)
            .map { [weak self] email, password in
                self?.isValid(email: email, password: password) ?? false
            }
            .assign(to: \.isFormValid, on: self)
            .store(in: &cancellables)
    }

    func isValid(email: String, password: String) -> Bool {
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        let isEmailValid = emailPredicate.evaluate(with: email)
        
        let isPasswordValid = password.count >= 6
        
        return isEmailValid && isPasswordValid
    }
    
    func createAccount(){
        guard isValid(email: email, password: password) else {
            print("Email or password is not valid")
            return
        }
        Task{
            do{
                let returnedUserData = try await authenticationManager.createUser(email: email, password: password)
                print("Successfully created user with email: \(returnedUserData)")
                await MainActor.run {
                    AuthenticationStateManager.shared.authenticate()
                }
            } catch{
                print("Error signing in user: \(error.localizedDescription)")
            }
        }
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
