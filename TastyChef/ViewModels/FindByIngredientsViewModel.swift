//
//  findByIngredientsViewModel.swift
//  TastyChef
//
//  Created by Ahmed Hamza on 3/28/25.
//

import Foundation


class FindByIngredientsViewModel: ObservableObject {
    @Published var ingredients: [String] = []
    @Published var recipes: [RecipeByIngredient] = []
    @Published var isLoading = false
    @Published var showError = false
    @Published var errorMessage: String?
    @Published var searchCompleted = false
    @Published var showInputSection = true
    @Published var newIngredient = ""
    @Published var recipeCount = 5.0
    @Published var ignorePantry = false
    
    var networkManager: NetworkManager
    
    init(networkManager: NetworkManager) {
        self.networkManager = networkManager
    }
    
    func addIngredient() {
        let trimmedIngredient = newIngredient.trimmingCharacters(in: .whitespacesAndNewlines)
        if !trimmedIngredient.isEmpty && !ingredients.contains(trimmedIngredient) {
            ingredients.append(trimmedIngredient)
            newIngredient = ""
        }
    }
    
    func addSpecificIngredient(_ ingredient: String) {
        let trimmedIngredient = ingredient.trimmingCharacters(in: .whitespacesAndNewlines)
        if !trimmedIngredient.isEmpty && !ingredients.contains(trimmedIngredient) {
            ingredients.append(trimmedIngredient)
        }
    }
    
    func deleteIngredient(_ ingredient: String) {
        ingredients.removeAll { $0 == ingredient }
    }
    
    func clearIngredients() {
        ingredients.removeAll()
    }
    
    func toggleInputSection() {
        showInputSection.toggle()
    }
    
    func showInputSectionWithValue(_ value: Bool) {
        showInputSection = value
    }
    
    func searchRecipes() async {
        guard !ingredients.isEmpty else { return }
        
        await fetchRecipesByIngredients(
            ingredient: ingredients.joined(separator: ","),
            number: Int(recipeCount),
            ignorePantry: ignorePantry
        )
        
        // Hides until search completes
        showInputSection = false
    }

    @MainActor
    func fetchRecipesByIngredients(ingredient: String, number: Int?, ignorePantry: Bool?) async {
        isLoading = true
        showError = false
        errorMessage = nil
        searchCompleted = false
        
        do{
            var queryItems = ["ingredients" : ""]
            queryItems["ingredients"] = "\(ingredient)"
            
            queryItems["number"] = "\(number ?? 3)"
            
            queryItems["ignorePantry"] = "\(ignorePantry ?? false)"

            let fetchedResults = try await networkManager.getDataFromWebService(url: APIEndpoints.searchByIngredients.createUrl(with: queryItems), modelType: [RecipeByIngredient].self)
            
            recipes = fetchedResults
            searchCompleted = true
        } catch {
            showError = true
            errorMessage = error.localizedDescription
        }
        
        isLoading = false
    }
}
