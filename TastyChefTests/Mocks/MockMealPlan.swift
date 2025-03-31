//
//  MockMealPlan.swift
//  TastyChef
//
//  Created by Ahmed Hamza on 3/31/25.
//

import Foundation
@testable import TastyChef

class MockMealPlan {
    static func createMockMeal(id: Int, title: String) -> MockMealPlanMeal {
        return MockMealPlanMeal(
            id: id,
            imageType: "jpg",
            title: title,
            readyInMinutes: 15 * id,
            servings: 2
        )
    }
    
    static func createMock() -> MockMealPlanModel {
        let meals = [
            createMockMeal(id: 1, title: "Breakfast"),
            createMockMeal(id: 2, title: "Lunch"),
            createMockMeal(id: 3, title: "Dinner")
        ]
        
        let nutrients = MockMealPlanNutrients(
            calories: 2000,
            protein: 100,
            fat: 70,
            carbohydrates: 200
        )
        
        return MockMealPlanModel(meals: meals, nutrients: nutrients)
    }
    
    static func getMealsCount(from mealPlan: MockMealPlanModel?) -> Int {
        return mealPlan?.getMealsCount() ?? 0
    }
    
    static func getMealTitle(from mealPlan: MockMealPlanModel?, at index: Int) -> String? {
        return mealPlan?.getMealTitle(at: index)
    }
    
    static func getNutrientCalories(from mealPlan: MockMealPlanModel?) -> Int? {
        return mealPlan?.getNutrientCalories()
    }
} 
