//
//  MockNetworkManager.swift
//  TastyChef
//
//  Created by Ahmed Hamza on 3/31/25.
//

import Foundation
@testable import TastyChef

class MockNetworkManager: NetworkManagerActions {
    // Properties for testing
    var shouldSucceed = true
    var mockResponse: Any?
    var mockError: Error = WebServiceError.noData
    var lastURL: URL?
    var lastParameters: [String: String]?
    var getDataFromWebServiceCalled = false
    
    var urlSession: URLSession = URLSession.shared
    
    init() { }
    
    func getDataFromWebService<T: Decodable>(url: URL?, modelType: T.Type) async throws -> T {
        getDataFromWebServiceCalled = true
        lastURL = url
        
        if let url = url, let components = URLComponents(url: url, resolvingAgainstBaseURL: true) {
            var params = [String: String]()
            components.queryItems?.forEach { item in
                params[item.name] = item.value
            }
            lastParameters = params
        }
        
        if modelType == MealPlan.self {
            if shouldSucceed, let MealPlan = mockResponse as? MockMealPlanModel {
                let decoder = JSONDecoder()
                
                let mealPlanDict: [String: Any] = [
                    "meals": MealPlan.meals.map { meal in
                        ["id": meal.id,
                         "imageType": meal.imageType,
                         "title": meal.title,
                         "readyInMinutes": meal.readyInMinutes,
                         "servings": meal.servings]
                    },
                    "nutrients": [
                        "calories": MealPlan.nutrients.calories,
                        "protein": MealPlan.nutrients.protein,
                        "fat": MealPlan.nutrients.fat,
                        "carbohydrates": MealPlan.nutrients.carbohydrates
                    ]
                ]
                
                let jsonData = try JSONSerialization.data(withJSONObject: mealPlanDict)
                
                if let result = try? decoder.decode(T.self, from: jsonData) {
                    return result
                }
            }
        } else if shouldSucceed, let response = mockResponse as? T {
            return response
        }
        
        throw mockError
    }
} 
