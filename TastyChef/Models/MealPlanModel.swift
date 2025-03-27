import Foundation

// MARK: - MealPlan
struct MealPlan: Codable {
    let week: Week
}

// MARK: - Week
struct Week: Codable {
    let monday, tuesday, wednesday, thursday, friday, saturday, sunday: Day
}

// MARK: - Day
struct Day: Codable {
    let meals: [Meal]
    let nutrients: Nutrient
}

// MARK: - Meal
struct Meal: Codable, Identifiable {
    let id: Int
    let image: String
    let imageType: String
    let title: String
    let readyInMinutes: Int
    let servings: Int
    let sourceUrl: String
}

// MARK: - Nutrients
struct Nutrient: Codable {
    let calories, protein, fat, carbohydrates: Double
} 
