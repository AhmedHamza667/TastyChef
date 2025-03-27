import Foundation

// MARK: - RecipeDetailModel
struct RecipeDetailModel: Codable, Identifiable {
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
}

// MARK: - ExtendedIngredient
struct ExtendedIngredient: Codable, Identifiable {
    let id: Int
    let image: String?
    let name: String
    let original: String
}

// MARK: - AnalyzedInstruction
struct AnalyzedInstruction: Codable {
    let steps: [Step]
}

// MARK: - Step
struct Step: Codable, Identifiable {
    let number: Int
    let step: String
    let equipment: [Equipment]
    
    var id: Int { number }
}

// MARK: - Equipment
struct Equipment: Codable {
    let id: Int
    let name: String
}

// MARK: - Nutrition
struct Nutrition: Codable {
    let nutrients: [Nutrients]
}

// MARK: - Nutrients
struct Nutrients: Codable, Identifiable {
    let name: String
    let amount: Double
    let unit: String
    
    var id: String { name }
}
