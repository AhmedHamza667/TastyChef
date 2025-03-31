//
//  MockAPIModels.swift
//  TastyChef
//
//  Created by Ahmed Hamza on 3/31/25.
//

import Foundation
@testable import TastyChef

struct MockResult: Codable {
    static func createMockResult(id: Int, title: String, image: String) -> Result {
        return Result(
            id: id,
            title: title,
            image: image
        )
    }
    
    static func createMockResults(count: Int) -> [Result] {
        return (1...count).map { index in
            createMockResult(
                id: index,
                title: "Recipe \(index)",
                image: "https://example.com/recipe\(index).jpg"
            )
        }
    }
}

struct MockPopularRecipesModel {
    static func createMock(results: [Result]) -> PopularRecipesModel {
        return PopularRecipesModel(
            results: results
        )
    }
}

struct MockRecipeDetail {
    static func createMock() -> RecipeDetailModel {
        return RecipeDetailModel(
            id: 123,
            title: "Test Recipe",
            image: "https://example.com/image.jpg",
            readyInMinutes: 30,
            servings: 4,
            sourceUrl: "https://example.com/recipe",
            aggregateLikes: 44,
            sourceName: "https://example.com/recipe",
            vegetarian: true,
            vegan: true,
            glutenFree: true,
            dairyFree: false,
            extendedIngredients: [],
            analyzedInstructions: [],
            nutrition: nil
        )
    }
}


