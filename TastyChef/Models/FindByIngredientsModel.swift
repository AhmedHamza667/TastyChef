//
//  RecipeByIngredient.swift
//  TastyChef
//
//  Created by Ahmed Hamza on 3/25/25.
//

import Foundation

struct RecipeByIngredient: Decodable, Identifiable {
    let id: Int
    let title: String
    let image: String
    let imageType: String
    let usedIngredientCount: Int
    let missedIngredientCount: Int
    let missedIngredients: [Ingredient]
    let usedIngredients: [Ingredient]
    let unusedIngredients: [Ingredient]
    let likes: Int
}

struct Ingredient: Decodable, Identifiable {
    let id: Int
    let amount: Double
    let unit: String
    let name: String
    let original: String
    let originalName: String
    let image: String
}

extension RecipeByIngredient {
    var imageURL: URL? {
        return URL(string: image)
    }
    
    var totalIngredientCount: Int {
        return usedIngredientCount + missedIngredientCount
    }
    
    var matchPercentage: Double {
        guard totalIngredientCount > 0 else { return 0 }
        return Double(usedIngredientCount) / Double(totalIngredientCount) * 100.0
    }
}

extension Ingredient {
    var imageURL: URL? {
        return URL(string: "https://spoonacular.com/cdn/ingredients_100x100/\(image)")
    }
    
    var formattedAmount: String {
        if amount == 0 {
            return ""
        } else if amount.truncatingRemainder(dividingBy: 1) == 0 {
            return "\(Int(amount))"
        } else {
            return "\(amount)"
        }
    }
    
    var displayText: String {
        var text = formattedAmount
        if !unit.isEmpty {
            text += text.isEmpty ? unit : " \(unit)"
        }
        return text.isEmpty ? name : "\(text) \(name)"
    }
} 
