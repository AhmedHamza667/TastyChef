//
//  MockMealPlanModels.swift
//  TastyChef
//
//  Created by Ahmed Hamza on 3/31/25.
//

import Foundation
@testable import TastyChef


struct MockMealPlanMeal {
    let id: Int
    let imageType: String
    let title: String
    let readyInMinutes: Int
    let servings: Int
}

struct MockMealPlanNutrients {
    let calories: Int
    let protein: Int
    let fat: Int
    let carbohydrates: Int
}

struct MockMealPlanModel {
    let meals: [MockMealPlanMeal]
    let nutrients: MockMealPlanNutrients
    
    func getMealsCount() -> Int {
        return meals.count
    }
    
    func getMealTitle(at index: Int) -> String? {
        guard index < meals.count else {
            return nil
        }
        return meals[index].title
    }
    
    func getNutrientCalories() -> Int {
        return nutrients.calories
    }
} 
