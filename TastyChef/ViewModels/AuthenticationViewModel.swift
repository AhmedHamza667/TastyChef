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
    @Published var isLoading = false
    @Published var error: String?
    @Published var showError = false


    private var authenticationManager: AuthenticationServiceProtocol
    private var authenticationStateManager: AuthenticationStateServiceProtocol
    private var cancellables = Set<AnyCancellable>()

    init(authenticationManager: AuthenticationServiceProtocol, authenticationStateManager: AuthenticationStateServiceProtocol) {
        self.authenticationManager = authenticationManager
        self.authenticationStateManager = authenticationStateManager
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
        guard isFormValid else {
            print("Email or password is not valid")
            return
        }
        Task{
            do{
                let returnedUserData = try await authenticationManager.createUser(email: email, password: password)
                print("Successfully created user with email: \(returnedUserData)")
                await MainActor.run {
                    isLoading = false
                    authenticationStateManager.authenticate()
                }
            } catch{
                await MainActor.run {
                    isLoading = false
                    self.error = (error.localizedDescription)
                    self.showError = true
                }
            }
        }
    }

    func logIn() {
            guard isFormValid else { return }
            
            isLoading = true
            error = nil
            
            Task {
                do {
                    let returnedUserData = try await authenticationManager.signIn(email: email, password: password)
                    print("Successfully Logged in user with email: \(returnedUserData.email ?? "")")
                    await MainActor.run {
                        isLoading = false
                        authenticationStateManager.authenticate()
                    }
                } catch {
                    await MainActor.run {
                        isLoading = false
                        self.error = "Invalid caardentials"
                        self.showError = true
                    }
                }
            }
        }
  
}
