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
}
