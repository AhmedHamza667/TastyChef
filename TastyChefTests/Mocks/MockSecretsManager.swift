//
//  MockSecretsManager.swift
//  TastyChef
//
//  Created by Ahmed Hamza on 3/31/25.
//
import Foundation

class MockSecretsManager {
    private var secretsDict: [String: Any]
    
    init(secretsDict: [String: Any]) {
        self.secretsDict = secretsDict
    }
    
    func getValue(forKey key: String) -> String? {
        return secretsDict[key] as? String
    }
} 
