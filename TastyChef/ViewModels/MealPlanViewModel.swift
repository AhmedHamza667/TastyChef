//
//  MealPlanViewModel.swift
//  TastyChef
//
//  Created by Ahmed Hamza on 3/27/25.
//

import Foundation

class MealPlanViewModel: ObservableObject {
    @Published var mealPlan: MealPlan?
    @Published var isLoading = false
    @Published var showError = false
    @Published var errorMessage: String?
    @Published var showingPlan = false
    
    // Form fields
    @Published var targetCalories: String = ""
    @Published var selectedDiet: String = "None"
    @Published var excludeIngredients: String = ""
    
    // Available options
    let diets = ["None", "Vegetarian", "Vegan", "Gluten Free", "Ketogenic", "Paleo"]

    var networkManager: NetworkManagerActions
    
    init(networkManager: NetworkManagerActions) {
        self.networkManager = networkManager
    }
    
    // generate meal plan
    func generatePlan() {
        guard !targetCalories.isEmpty, let calories = Int(targetCalories) else {
            showError = true
            errorMessage = "Please enter a valid calorie target"
            return
        }
        
        let diet = selectedDiet == "None" ? nil : selectedDiet.lowercased()
        let exclude = excludeIngredients.isEmpty ? nil : excludeIngredients
            .split(separator: ",")
            .map { $0.trimmingCharacters(in: .whitespaces) }
            .joined(separator: ",")
        
        Task {
            await generateMealPlan(
                targetCalories: calories,
                diet: diet,
                exclude: exclude
            )
        }
    }
    
    // Reset form
    func resetForm() {
        targetCalories = ""
        selectedDiet = "None"
        excludeIngredients = ""
    }
    
    // Check if form is valid
    var isFormValid: Bool {
        !targetCalories.isEmpty && Int(targetCalories) != nil
    }
    
    @MainActor
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
    
    @MainActor
    func clearMealPlan() {
        mealPlan = nil
        showingPlan = false
    }
}


