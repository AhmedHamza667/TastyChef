//
//  CoreDataManager.swift
//  TastyChef
//
//  Created by Ahmed Hamza on 3/24/25.
//

import CoreData


protocol CoreDataServiceProtocol {
    var context: NSManagedObjectContext { get }
    func save()
    func addToFavorites(id: Int32, title: String, image: String)
    func removeFromFavorites(id: Int32)
    func isRecipeFavorited(id: Int32) -> Bool
    func getAllFavorites() -> [FavRecipes]
    func resetAllFavorites()
}

class CoreDataManager: CoreDataServiceProtocol, ObservableObject {
    init(containerName: String = "FavoriteRecipesContainer") {
        container = NSPersistentContainer(name: containerName)

        container.loadPersistentStores { description, error in
            if let error = error {
                print("Core Data failed to load: \(error.localizedDescription)")
            }
        }
    }
    
    let container: NSPersistentContainer
    
    var context: NSManagedObjectContext {
        container.viewContext
    }
    
    func save() {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                print("Error saving context: \(error)")
            }
        }
    }
    
    func addToFavorites(id: Int32, title: String, image: String) {
        let recipe = FavRecipes(context: context)
        recipe.id = id
        recipe.title = title
        recipe.image = image
        save()
    }
    
    func removeFromFavorites(id: Int32) {
        let fetchRequest: NSFetchRequest<FavRecipes> = FavRecipes.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %d", id)
        
        do {
            let results = try context.fetch(fetchRequest)
            if let recipe = results.first {
                context.delete(recipe)
                save()
            }
        } catch {
            print("Error removing favorite: \(error)")
        }
    }
    
    func isRecipeFavorited(id: Int32) -> Bool {
        let fetchRequest: NSFetchRequest<FavRecipes> = FavRecipes.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %d", id)
        
        do {
            let count = try context.count(for: fetchRequest)
            return count > 0
        } catch {
            print("Error checking favorite status: \(error)")
            return false
        }
    }
    
    func getAllFavorites() -> [FavRecipes] {
        let fetchRequest: NSFetchRequest<FavRecipes> = FavRecipes.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(keyPath: \FavRecipes.title, ascending: true)]
        
        do {
            return try context.fetch(fetchRequest)
        } catch {
            print("Error fetching favorites: \(error)")
            return []
        }
    }
    
    func resetAllFavorites() {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = FavRecipes.fetchRequest()
        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        do {
            try context.execute(batchDeleteRequest)
            save()
        } catch {
            print("Error resetting favorites: \(error)")
        }
    }
} 
