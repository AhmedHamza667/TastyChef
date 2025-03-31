//
//  RecipeDetailModel.swift
//  TastyChef
//
//  Created by Ahmed Hamza on 3/25/25.
//

import Foundation

struct RecipeDetailModel: Decodable, Identifiable {
    let id: Int
    let title: String
    let image: String
    let readyInMinutes: Int
    let servings: Int
    let sourceUrl: String
    let aggregateLikes: Int
    let sourceName: String
    let vegetarian: Bool
    let vegan: Bool
    let glutenFree: Bool
    let dairyFree: Bool
    let extendedIngredients: [ExtendedIngredient]
    let analyzedInstructions: [AnalyzedInstruction]
    let nutrition: Nutrition?
    
    // Computed property for dietary restrictions
    var dietaryInfo: [String] {
        var info: [String] = []
        if vegetarian { info.append("Vegetarian") }
        if vegan { info.append("Vegan") }
        if glutenFree { info.append("Gluten-Free") }
        if dairyFree { info.append("Dairy-Free") }
        return info
    }
    
    // (no duplicates in ingredients)
    var uniqueIngredients: [ExtendedIngredient] {
        let uniqueDict = Dictionary(grouping: extendedIngredients) { $0.name.lowercased().trimmingCharacters(in: .whitespacesAndNewlines) }
            .compactMapValues { $0.first }
        
        return Array(uniqueDict.values).sorted { $0.name < $1.name }
    }
    
    // (no duplicates in steps)
    var uniqueInstructions: [Step] {
        let allSteps = analyzedInstructions.flatMap { $0.steps }
        let uniqueDict = Dictionary(grouping: allSteps) { $0.step.lowercased().trimmingCharacters(in: .whitespacesAndNewlines) }
            .compactMapValues { $0.first }
            .values
            .sorted { $0.number < $1.number }
            
        return uniqueDict.enumerated().map { index, step in
            var newStep = step
            newStep.number = index + 1
            return newStep
        }
    }
}

struct ExtendedIngredient: Decodable, Identifiable {
    let id: Int
    let image: String?
    let name: String
    let original: String
    var imageURL: String {
        "https://spoonacular.com/cdn/ingredients_100x100/\(image ?? "")"
    }

    // avoid duplicate ID issues in ForEach
    var uniqueId: String {
        "\(id)-\(name.replacingOccurrences(of: " ", with: "-"))"
    }
}

struct AnalyzedInstruction: Decodable {
    let steps: [Step]
}

struct Step: Decodable, Identifiable {
    var number: Int
    let step: String
    let equipment: [Equipment]
    
    var id: Int { number }
    
    // to avoid duplicate ID issues in ForEach
    var uniqueId: String {
        "\(number)-\(step.prefix(20).replacingOccurrences(of: " ", with: "-"))"
    }
}

struct Equipment: Decodable {
    let id: Int
    let name: String
}

struct Nutrition: Decodable {
    let nutrients: [Nutrients]
}

struct Nutrients: Decodable, Identifiable {
    let name: String
    let amount: Double
    let unit: String
    
    var id: String { name }
}
