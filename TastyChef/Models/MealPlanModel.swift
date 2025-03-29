//
//  MealPlan.swift
//  TastyChef
//
//  Created by Ahmed Hamza on 3/25/25.
//

import Foundation

struct MealPlan: Decodable {
    let week: Week
}

struct Week: Decodable {
    let monday, tuesday, wednesday, thursday, friday, saturday, sunday: Day
}

struct Day: Decodable {
    let meals: [Meal]
    let nutrients: Nutrient
}

struct Meal: Decodable, Identifiable {
    let id: Int
    let image: String
    var imageURL: String {
        "https://spoonacular.com/recipeImages/\(image)"
    }
    let title: String
    let readyInMinutes: Int
    let servings: Int
    let sourceUrl: String
}

struct Nutrient: Decodable {
    let calories, protein, fat, carbohydrates: Double
} 
