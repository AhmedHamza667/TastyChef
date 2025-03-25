//
//  AuthenticationManager.swift
//  TastyChef
//
//  Created by Ahmed Hamza on 3/24/25.
//

import Foundation
import FirebaseAuth
class AuthenticationManager{
        
    func createUser(email: String, password: String) async throws -> AuthDataModel{
        let authenticatedUser = try await Auth.auth().createUser(withEmail: email, password: password)
        return AuthDataModel(uid: authenticatedUser.user.uid, email: authenticatedUser.user.email)
    }
    
    func signIn(email: String, password: String) async throws -> AuthDataModel{
        let authenticatedUser = try await Auth.auth().signIn(with: EmailAuthProvider.credential(withEmail: email, password: password))
        return AuthDataModel(uid: authenticatedUser.user.uid, email: authenticatedUser.user.email)
    }
    
    func getAuthenticatedUser() throws -> AuthDataModel {
        guard let user = Auth.auth().currentUser else {
            throw URLError(.badServerResponse)
        }
        return AuthDataModel(uid: user.uid, email: user.email)
    }
    
    func signOut() throws{
        try Auth.auth().signOut()
    }
}
