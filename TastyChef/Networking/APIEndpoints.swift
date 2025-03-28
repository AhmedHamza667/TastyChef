//
//  APIEndpoints.swift
//  TastyChef
//
//  Created by Ahmed Hamza on 3/25/25.
//
//APIEndpoint.swift

import Foundation



enum APIEndpoints {
    // Base URL
    static let baseURL = "https://api.spoonacular.com"
    static let apiKey = SecretsManager.shared.getValue(forKey: "API_KEY") ?? "" // or API_KEY2

    // Endpoints
    case recipes
    case recipeDetails(id: Int)
    case searchRecipes
    case randomRecipes
    case mealPlan
    case recipeNutritionLabel(id: Int)
    case searchByIngredients
    
    // get the full path
    var path: String {
        switch self {
        case .recipes:
            return "/recipes/complexSearch"
        case .recipeDetails(let id):
            return "/recipes/\(id)/information"
        case .recipeNutritionLabel(let id):
            return "/recipes/\(id)/nutritionLabel"
        case .searchRecipes:
            return "/recipes/complexSearch"
        case .randomRecipes:
            return "/recipes/random"
        case .mealPlan:
            return "/mealplanner/generate"
        case .searchByIngredients:
            return "/recipes/findByIngredients"
        }
    }
    
    // full URL with path
    var url: URL? {
        return URL(string: APIEndpoints.baseURL + path)
    }
    
    // create URL with query parameters
    func createUrl(with parameters: [String: Any]? = nil) -> URL? {
        guard var components = URLComponents(string: APIEndpoints.baseURL + path) else {
            return nil
        }
        
        var queryParameters = parameters ?? [:]
        queryParameters["apiKey"] = APIEndpoints.apiKey
        
        // pass parameters
        components.queryItems = queryParameters.map { key, value in
            URLQueryItem(name: key, value: "\(value)")
        }

        return components.url
    }
    
}
