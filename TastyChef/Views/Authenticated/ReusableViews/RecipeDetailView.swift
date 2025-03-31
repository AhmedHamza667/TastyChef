//
//  RecipeDetailView.swift
//  TastyChef
//
//  Created by Ahmed Hamza on 3/26/25.
//

import SwiftUI
import SDWebImageSwiftUI

struct RecipeDetailView: View {
    let recipeId: Int
    @StateObject private var viewModel = RecipeDetailViewModel(networkManager: NetworkManager())
    @Environment(\.dismiss) private var dismiss
    @StateObject private var favoritesVM = FavoritesViewModel(coreDataManager: CoreDataManager())

    
    var body: some View {
        ZStack(alignment: .top) {
            // Main content
            VStack(spacing: 0) {
                ScrollView {
                    VStack(spacing: 0) {
                        switch viewModel.viewState {
                        case .loading:
                            LoadingView()
                                .frame(minHeight: UIScreen.main.bounds.height - 100)
                        case .loaded:
                            if let recipe = viewModel.recipeDetails {
                                VStack(alignment: .leading, spacing: 0) {
                                    // Image without buttons
                                    WebImage(url: URL(string: recipe.image)) { image in
                                        image
                                            .resizable()
                                            .aspectRatio(contentMode: .fill)
                                    } placeholder: {
                                        Rectangle()
                                            .fill(Color.gray.opacity(0.2))
                                    }
                                    .frame(height: 300)
                                    .clipped()
                                    
                                    // Content
                                    VStack(alignment: .leading, spacing: 20) {
                                        // Title and Stats
                                        VStack(alignment: .leading, spacing: 8) {
                                            Text(recipe.title)
                                                .font(.title)
                                                .fontWeight(.bold)
                                            
                                            HStack(spacing: 15) {
                                                StatView(icon: "clock", value: "\(recipe.readyInMinutes)", text: "mins")
                                                StatView(icon: "person.2", value: "\(recipe.servings)", text: "servings")
                                                StatView(icon: "heart.fill", value: "\(recipe.aggregateLikes)", text: "likes")
                                            }
                                        }
                                        
                                        // Dietary Tags
                                        if !recipe.dietaryInfo.isEmpty {
                                            ScrollView(.horizontal, showsIndicators: false) {
                                                HStack {
                                                    ForEach(recipe.dietaryInfo, id: \.self) { diet in
                                                        Text(diet)
                                                            .font(.caption)
                                                            .padding(.horizontal, 12)
                                                            .padding(.vertical, 6)
                                                            .background(Color("colorPrimary").opacity(0.1))
                                                            .foregroundColor(Color("colorPrimary"))
                                                            .clipShape(Capsule())
                                                    }
                                                }
                                            }
                                        }
                                        
                                        
                                        Divider()
                                        
                                        // Nutrition Facts Section
                                        VStack(alignment: .leading, spacing: 12) {
                                            Text("Nutrition Facts")
                                                .font(.title2)
                                                .fontWeight(.bold)
                                            
                                            VStack(spacing: 12) {
                                                if let nutrients = recipe.nutrition?.nutrients {
                                                    let wantedNutrients = ["Calories", "Protein", "Carbohydrates", "Fat", "Sugar"]
                                                    
                                                    ForEach(nutrients.filter { wantedNutrients.contains($0.name) }) { nutrient in
                                                        NutritionRow(
                                                            title: nutrient.name,
                                                            value: "\(nutrient.amount)\(nutrient.unit)"
                                                        )
                                                    }
                                                }
                                            }
                                            .padding()
                                            .background(Color.gray.opacity(0.1))
                                            .cornerRadius(12)
                                        }
                                        
                                        Divider()
                                        
                                        // Ingredients
                                        IngredientsView(recipe: recipe)
                                        
                                        Divider()
                                        
                                        // Instructions
                                        InstructionsView(recipe: recipe)
                                        
                                        // Nutrition Label
                                        NutritionLabelView(recipeID: recipe.id, viewModel: viewModel)
                                            .frame(height: 650)

                                        // Source Attribution
                                        VStack(alignment: .leading, spacing: 4) {
                                            Text("Source: \(recipe.sourceName)")
                                                .font(.caption)
                                                .foregroundColor(.secondary)
                                            if let url = URL(string: recipe.sourceUrl) {
                                                Link("View Original Recipe", destination: url)
                                                    .font(.caption)
                                            }
                                        }

                                    }
                                    .padding(.horizontal, 30)
                                    .padding(.vertical, 16)
                                    .background(Color(.systemBackground))
                                }
                            }
                        case .error(let error):
                            VStack {
                                ErrorView(error: error, retryAction: {
                                    Task {
                                        await viewModel.getRecipeDetail(recipeId: recipeId)
                                    }
                                })
                            }
                            .frame(minHeight: UIScreen.main.bounds.height - 100)
                        case .empty:
                            EmptyView()
                        }
                    }
                }
            }
            .ignoresSafeArea(.container, edges: .top)
            
            // Fixed buttons overlay
            HStack {
                // Back button
                Button(action: {
                    dismiss()
                }) {
                    HStack {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 16, weight: .semibold))
                        Text("Back")
                    }
                    .foregroundColor(.white)
                    .padding(12)
                    .background(Color.black.opacity(0.6))
                    .cornerRadius(20)
                }
                
                Spacer()
                
                // Favorite button (only show when recipe is loaded)
                if let recipe = viewModel.recipeDetails {
                    Button(action: {
                        favoritesVM.toggleFavorite(
                            id: Int32(recipe.id),
                            title: recipe.title,
                            image: recipe.image
                        )
                    }) {
                        Image(systemName: favoritesVM.isRecipeFavorited(id: Int32(recipe.id)) ? "heart.fill" : "heart")
                            .font(.system(size: 20, weight: .semibold))
                            .padding(12)
                            .background(Color(.systemBackground))
                            .foregroundColor(
                                favoritesVM.isRecipeFavorited(id: Int32(recipe.id)) ? .red : .primary
                            )
                            .cornerRadius(12)
                            .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
                    }
                }
            }
            .padding(.horizontal, 35)
        }
        .navigationBarBackButtonHidden()
        .toolbarBackground(.hidden, for: .navigationBar)
        .task {
            await viewModel.getRecipeDetail(recipeId: recipeId)
        }
    }
}

#Preview {
    NavigationView {
        RecipeDetailView(recipeId: 990586)
    }
}

// Supporting Views
struct NutritionRow: View {
    let title: String
    let value: String
    
    var body: some View {
        HStack {
            Text(title)
                .foregroundColor(.secondary)
            Spacer()
            Text(value)
                .fontWeight(.semibold)
        }
    }
}

struct StatView: View {
    let icon: String
    let value: String
    let text: String
    
    var body: some View {
        VStack {
            Image(systemName: icon)
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(Color("colorPrimary"))
            HStack(alignment: .firstTextBaseline, spacing: 2) {
                Text(value)
                    .font(.system(size: 16, weight: .semibold))
                Text(text)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
    }
}



struct IngredientsView: View {
    var recipe: RecipeDetailModel
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Ingredients")
                .font(.title2)
                .fontWeight(.bold)
            
            // Use uniqueIngredients to avoid duplicates 
            ForEach(recipe.uniqueIngredients, id: \.uniqueId) { ingredient in
                HStack {
                    WebImage(url: URL(string: "\(ingredient.imageURL)")) { image in
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                    } placeholder: {
                        Circle()
                            .fill(Color.gray.opacity(0.2))
                    }
                    .frame(width: 40, height: 40)
                    
                    VStack(alignment: .leading) {
                        Text(ingredient.name.capitalized)
                            .font(.subheadline)
                        Text(ingredient.original)
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
            }
        }
    }
}

struct InstructionsView: View {
    var recipe: RecipeDetailModel
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Instructions")
                .font(.title2)
                .fontWeight(.bold)
            
            // Use uniqueInstructions to avoid duplicates
            ForEach(recipe.uniqueInstructions, id: \.uniqueId) { step in
                VStack(alignment: .leading, spacing: 8) {
                    Text("Step \(step.number)")
                        .font(.headline)
                        .foregroundColor(Color("colorPrimary"))
                    
                    Text(step.step)
                        .font(.body)
                    
                    if !step.equipment.isEmpty {
                        Text("Equipment needed:")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        HStack {
                            ForEach(Array(zip(step.equipment.indices, step.equipment)), id: \.0) { index, equipment in
                                Text(equipment.name)
                                    .font(.caption)
                                    .padding(.horizontal, 8)
                                    .padding(.vertical, 4)
                                    .background(Color.gray.opacity(0.1))
                                    .cornerRadius(4)
                            }
                        }
                    }
                }
                .padding(.vertical, 8)
            }
        }
    }
}
