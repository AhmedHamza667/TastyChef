//
//  FavoritesViewModel.swift
//  TastyChef
//
//  Created by Ahmed Hamza on 3/24/25.
//

import SwiftUI
import CoreData

class FavoritesViewModel: ObservableObject {
    static let shared = FavoritesViewModel()
    
    @Published var favorites: [Result] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private let coreDataManager = CoreDataManager.shared
    
    init() {
        loadFavorites()
    }
    
    func loadFavorites() {
        isLoading = true
        let favRecipes = coreDataManager.getAllFavorites()
        favorites = favRecipes.map { recipe in
            Result(
                id: Int(recipe.id),
                title: recipe.title ?? "",
                image: recipe.image ?? ""
            )
        }
        isLoading = false
    }
    
    func toggleFavorite(id: Int32, title: String, image: String) {
        if coreDataManager.isRecipeFavorited(id: id) {
            coreDataManager.removeFromFavorites(id: id)
        } else {
            coreDataManager.addToFavorites(id: id, title: title, image: image)
        }
        loadFavorites()
    }
    
    func removeFavorite(id: Int32) {
        coreDataManager.removeFromFavorites(id: id)
        loadFavorites()
    }
    
    func isRecipeFavorited(id: Int32) -> Bool {
        coreDataManager.isRecipeFavorited(id: id)
    }
    
    func resetAllFavorites() {
        coreDataManager.resetAllFavorites()
        loadFavorites()
    }
    
    private func handleError(_ error: Error) {
        errorMessage = error.localizedDescription
    }
}
