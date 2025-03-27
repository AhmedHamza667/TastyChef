//
//  RecipeDetailViewModel.swift
//  TastyChef
//
//  Created by Ahmed Hamza on 3/26/25.
//

import Foundation

enum RecipeDetailViewState {
    case loading
    case loaded
    case error(Error)
    case empty
}

class RecipeDetailViewModel: ObservableObject {
    @Published var recipeDetails: RecipeDetailModel?
    @Published var nutritionLabelHTML: String?
    @Published var viewState: RecipeDetailViewState = .empty
    var networkManager: NetworkManager!
    
    init(networkManager: NetworkManager!) {
        self.networkManager = networkManager
    }
    
    @MainActor
    func getRecipeDetail(recipeId: Int) async {
        do {
            viewState = .loading
            let fetchedDetails = try await networkManager.getDataFromWebService(url: APIEndpoints.recipeDetails(id: recipeId).createUrl(with: ["includeNutrition" : "true"]), modelType: RecipeDetailModel.self)
            recipeDetails = fetchedDetails
            viewState = .loaded
        } catch {
            print("Error fetching recipe details: \(error.localizedDescription)")
            viewState = .error(error)
        }
    }
    
    @MainActor
    func getRecipeNutritionLabel(recipeId: Int) async {
        do {
            guard let url = APIEndpoints.recipeNutritionLabel(id: recipeId).createUrl() else { return  }
            let (data, _) = try await URLSession.shared.data(from: url)
            if let htmlString = String(data: data, encoding: .utf8) {
                nutritionLabelHTML = htmlString
            }
        } catch {
            print("Error fetching nutrition label: \(error.localizedDescription)")
        }
    }
}
