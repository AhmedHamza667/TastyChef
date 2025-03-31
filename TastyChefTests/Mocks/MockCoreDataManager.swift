//
//  MockCoreDataManager.swift
//  TastyChef
//
//  Created by Ahmed Hamza on 3/31/25.
//

import Foundation
import CoreData
@testable import TastyChef

class MockCoreDataManager: CoreDataServiceProtocol {
    private var favorites: [MockFavRecipe] = []
    
    var context: NSManagedObjectContext {
        let container = NSPersistentContainer(name: "Unused")
        return container.viewContext
    }
    
    func save() {
    }
    
    func addToFavorites(id: Int32, title: String, image: String) {
        favorites.append(MockFavRecipe(id: id, title: title, image: image))
    }
    
    func removeFromFavorites(id: Int32) {
        favorites.removeAll { $0.id == id }
    }
    
    func isRecipeFavorited(id: Int32) -> Bool {
        return favorites.contains { $0.id == id }
    }
    
    func getAllFavorites() -> [FavRecipes] {
        return []
    }
    
    func getMockFavorites() -> [MockFavRecipe] {
        return favorites.sorted { ($0.title ?? "") < ($1.title ?? "") }
    }
    
    func resetAllFavorites() {
        favorites.removeAll()
    }
} 
