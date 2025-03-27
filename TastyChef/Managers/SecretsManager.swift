//
//  SecretsManager.swift
//  TastyChef
//
//  Created by Ahmed Hamza on 3/27/25.
//

import Foundation

class SecretsManager {
    static let shared = SecretsManager()
    
    private var secrets: [String: Any]?

    private init() {
        if let url = Bundle.main.url(forResource: "Secrets", withExtension: "plist"),
           let data = try? Data(contentsOf: url),
           let dictionary = try? PropertyListSerialization.propertyList(from: data, options: [], format: nil) as? [String: Any] {
            secrets = dictionary
        }
    }

    func getValue(forKey key: String) -> String? {
        return secrets?[key] as? String
    }
}
