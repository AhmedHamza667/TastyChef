//
//  MealPlanViewModel.swift
//  TastyChef
//
//  Created by Ahmed Hamza on 3/27/25.
//

import Foundation

@MainActor
class MealPlanViewModel: ObservableObject {
    @Published var mealPlan: MealPlan?
    @Published var isLoading = false
    @Published var showError = false
    @Published var errorMessage: String?
    @Published var showingPlan = false

    var networkManager: NetworkManager
    
    init(networkManager: NetworkManager) {
        self.networkManager = networkManager
    }
    
    func generateMealPlan(targetCalories: Int, diet: String?, exclude: String?) async {
        isLoading = true
        showError = false
        errorMessage = nil
        
        do {
            var queryItems =
                ["targetCalories" : "\(targetCalories)"]
            
            
            if let diet = diet {
                queryItems["diet"] = "\(diet)"
            }
            
            if let exclude = exclude {
                queryItems["exclude"] = "\(exclude)"
            }
            
            
            let fetchedResults = try await networkManager.getDataFromWebService(
                url: APIEndpoints.mealPlan.createUrl(with: queryItems),
                modelType: MealPlan.self
            )

            mealPlan = fetchedResults
            showingPlan = true
        } catch {
            showError = true
            errorMessage = error.localizedDescription
        }
        
        isLoading = false
    }
    
    func clearMealPlan() {
        mealPlan = nil
        showingPlan = false
    }
}


