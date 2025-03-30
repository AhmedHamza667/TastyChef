//
//  AuthenticationManager.swift
//  TastyChef
//
//  Created by Ahmed Hamza on 3/24/25.
//

import Foundation
import FirebaseAuth
import UIKit
import FirebaseStorage


protocol AuthenticationServiceProtocol {
    func createUser(email: String, password: String) async throws -> AuthDataModel
    func signIn(email: String, password: String) async throws -> AuthDataModel
    func getAuthenticatedUser() throws -> AuthDataModel
    func updateDisplayName(displayName: String) async throws
    func signOut() throws
}

class AuthenticationManager: AuthenticationServiceProtocol {
        
    func createUser(email: String, password: String) async throws -> AuthDataModel {
        let authenticatedUser = try await Auth.auth().createUser(withEmail: email, password: password)
        return AuthDataModel(uid: authenticatedUser.user.uid, 
                            email: authenticatedUser.user.email,
                            displayName: authenticatedUser.user.displayName,
                            photoURL: authenticatedUser.user.photoURL)
    }
    
    func signIn(email: String, password: String) async throws -> AuthDataModel {
        let authenticatedUser = try await Auth.auth().signIn(with: EmailAuthProvider.credential(withEmail: email, password: password))
        return AuthDataModel(uid: authenticatedUser.user.uid, 
                            email: authenticatedUser.user.email,
                            displayName: authenticatedUser.user.displayName,
                            photoURL: authenticatedUser.user.photoURL)
    }
    
    func getAuthenticatedUser() throws -> AuthDataModel {
        guard let user = Auth.auth().currentUser else {
            throw URLError(.badServerResponse)
        }
        return AuthDataModel(uid: user.uid, 
                            email: user.email,
                            displayName: user.displayName,
                            photoURL: user.photoURL)
    }
    
    func updateDisplayName(displayName: String) async throws {
        guard let user = Auth.auth().currentUser else {
            throw URLError(.badURL)
        }
        
        let changeRequest = user.createProfileChangeRequest()
        changeRequest.displayName = displayName
        try await changeRequest.commitChanges()
    }
    
    
    func signOut() throws {
        try Auth.auth().signOut()
    }
}
