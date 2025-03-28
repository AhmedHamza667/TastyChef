//
//  SearchView.swift
//  TastyChef
//
//  Created by Ahmed Hamza on 3/25/25.
//

import SwiftUI

struct SearchView: View {
    @StateObject private var viewModel = findByIngredientsViewModel(networkManager: NetworkManager())
    
    var body: some View {
        NavigationView {
            ZStack {
                Color(.systemGray6).ignoresSafeArea()
                
                VStack(spacing: 0) {
                    if viewModel.showInputSection {
                        // Ingredients Input
                        VStack(spacing: 16) {
                            Text("Find Recipes By Ingredients")
                                .font(.headline)
                                .padding(.top)
                            
                            HStack {
                                TextField("Add ingredient (e.g., chicken)", text: $viewModel.newIngredient)
                                    .padding()
                                    .background(Color(.systemBackground))
                                    .cornerRadius(8)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 8)
                                            .stroke(Color.gray.opacity(0.2), lineWidth: 1)
                                    )
                                
                                Button(action: { viewModel.addIngredient() }) {
                                    Image(systemName: "plus.circle.fill")
                                        .font(.title2)
                                        .foregroundColor(.green)
                                }
                                .disabled(viewModel.newIngredient.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                            }
                            
                            // Ingredients List
                            if !viewModel.ingredients.isEmpty {
                                ScrollView(.horizontal, showsIndicators: false) {
                                    HStack(spacing: 8) {
                                        ForEach(viewModel.ingredients, id: \.self) { ingredient in
                                            IngredientChip(
                                                ingredient: ingredient,
                                                onDelete: { viewModel.deleteIngredient(ingredient) }
                                            )
                                        }
                                    }
                                    .padding(.vertical, 4)
                                }
                                .padding(.horizontal, -8)
                            }
                            
                            // Settings
                            VStack(spacing: 16) {
                                // Number of Recipes
                                VStack(alignment: .leading, spacing: 8) {
                                    Text("Number of Recipes: \(Int(viewModel.recipeCount))")
                                        .font(.subheadline)
                                        .foregroundColor(.secondary)
                                    
                                    Slider(value: $viewModel.recipeCount, in: 1...15, step: 1)
                                        .accentColor(.green)
                                }
                                
                                // Ignore Pantry Toggle
                                Toggle(isOn: $viewModel.ignorePantry) {
                                    Text("Ignore Pantry Ingredients")
                                        .font(.subheadline)
                                        .foregroundColor(.secondary)
                                }
                                .toggleStyle(SwitchToggleStyle(tint: .green))
                            }
                            .padding()
                            .background(Color(.systemBackground))
                            .cornerRadius(12)
                            
                            // Search Button
                            Button(action: {
                                Task {
                                    await viewModel.searchRecipes()
                                }
                            }) {
                                HStack {
                                    if viewModel.isLoading {
                                        ProgressView()
                                            .progressViewStyle(CircularProgressViewStyle())
                                            .tint(.white)
                                    } else {
                                        Text("Find Recipes")
                                            .fontWeight(.semibold)
                                    }
                                }
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(viewModel.ingredients.isEmpty ? Color.gray : Color.green)
                                .foregroundColor(.white)
                                .cornerRadius(12)
                            }
                            .disabled(viewModel.isLoading || viewModel.ingredients.isEmpty)
                        }
                        .padding()
                        .background(Color(.systemBackground))
                        .cornerRadius(16)
                        .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
                        .padding(.horizontal)
                        .padding(.top)
                        .transition(.move(edge: .top).combined(with: .opacity))
                    } else if !viewModel.recipes.isEmpty {
                        // Show filters summary and edit button when input is hidden
                        VStack(alignment: .leading, spacing: 10) {
                            HStack {
                                VStack(alignment: .leading, spacing: 4) {
                                    Text("Recipes for:")
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                    
                                    ScrollView(.horizontal, showsIndicators: false) {
                                        HStack(spacing: 8) {
                                            ForEach(viewModel.ingredients, id: \.self) { ingredient in
                                                Text(ingredient)
                                                    .font(.subheadline)
                                                    .padding(.horizontal, 8)
                                                    .padding(.vertical, 4)
                                                    .background(Color(.systemGray5))
                                                    .cornerRadius(8)
                                            }
                                        }
                                    }
                                }
                                Spacer()
                                
                                Button(action: { 
                                    withAnimation { 
                                        viewModel.showInputSectionWithValue(true) 
                                    }
                                }) {
                                    Label("Edit", systemImage: "slider.horizontal.3")
                                        .font(.subheadline)
                                        .foregroundColor(.green)
                                }
                                .padding(8)
                                .background(Color(.systemBackground))
                                .cornerRadius(8)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(Color.green, lineWidth: 1)
                                )
                            }
                        }
                        .padding()
                        .background(Color(.systemBackground))
                        .cornerRadius(16)
                        .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
                        .padding(.horizontal)
                        .padding(.top)
                        .transition(.move(edge: .top).combined(with: .opacity))
                    }
                    
                    // Results Section
                    if viewModel.isLoading {
                        Spacer()
                        ProgressView("Searching for recipes...")
                            .progressViewStyle(CircularProgressViewStyle())
                        Spacer()
                    } else if !viewModel.recipes.isEmpty {
                        ScrollView {
                            LazyVStack(spacing: 16) {
                                ForEach(viewModel.recipes) { recipe in
                                    NavigationLink(destination: RecipeDetailView(recipeId: recipe.id)) {
                                        IngredientSearchRecipeCard(recipe: recipe)
                                    }
                                    .buttonStyle(PlainButtonStyle())
                                }
                            }
                            .padding()
                        }
                    } else if viewModel.showError {
                        Spacer()
                        VStack(spacing: 10) {
                            Image(systemName: "exclamationmark.triangle")
                                .font(.largeTitle)
                                .foregroundColor(.orange)
                            
                            Text("Error")
                                .font(.headline)
                            
                            Text(viewModel.errorMessage ?? "Something went wrong.")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                                .multilineTextAlignment(.center)
                                .padding(.horizontal)
                            
                            Button("Try Again") {
                                Task {
                                    await viewModel.searchRecipes()
                                }
                            }
                            .padding(.vertical, 8)
                            .padding(.horizontal, 16)
                            .background(Color.green)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                            .padding(.top, 8)
                        }
                        .padding()
                        Spacer()
                    } else if !viewModel.ingredients.isEmpty {
                        Spacer()
                        Text("Enter ingredients and tap 'Find Recipes'")
                            .foregroundColor(.secondary)
                        Spacer()
                    } else {
                        Spacer()
                        VStack(spacing: 16) {
                            Image(systemName: "carrot")
                                .font(.system(size: 50))
                                .foregroundColor(.green.opacity(0.8))
                            
                            Text("Add ingredients to find recipes")
                                .font(.headline)
                            
                            Text("Enter the ingredients you have, and we'll find recipes you can make.")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                                .multilineTextAlignment(.center)
                                .padding(.horizontal)
                        }
                        .padding()
                        Spacer()
                    }
                }
            }
            .navigationTitle("Recipe Search")
            .navigationBarTitleDisplayMode(.inline)
            .alert("Error", isPresented: $viewModel.showError) {
                Button("OK", role: .cancel) { }
            } message: {
                Text(viewModel.errorMessage ?? "An error occurred")
            }
        }
    }
}

struct IngredientChip: View {
    let ingredient: String
    let onDelete: () -> Void
    
    var body: some View {
        HStack(spacing: 4) {
            Text(ingredient)
                .font(.subheadline)
                .padding(.leading, 8)
            
            Button(action: onDelete) {
                Image(systemName: "xmark.circle.fill")
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            .padding(.trailing, 6)
        }
        .padding(.vertical, 6)
        .background(Color(.systemGray5))
        .cornerRadius(16)
    }
}

struct IngredientSearchRecipeCard: View {
    let recipe: RecipeByIngredient
    
    var body: some View {
        VStack(spacing: 10) {
            RecipeCardView(recipe: Result(
                id: recipe.id,
                title: recipe.title,
                image: recipe.image
            ))
            
            VStack(spacing: 8) {
                HStack {
                    Text("Ingredient Match")
                        .font(.subheadline)
                        .fontWeight(.medium)
                    
                    Spacer()
                    
                    Text("\(Int(recipe.matchPercentage))% match")
                        .font(.subheadline)
                        .foregroundColor(.green)
                        .fontWeight(.semibold)
                }
                
                // Progress bar
                ProgressBar(value: recipe.matchPercentage / 100)
                    .frame(height: 6)
                
                // Ingredient counts
                HStack {
                    IngredientCount(
                        count: recipe.usedIngredientCount,
                        label: "Ingredients you have",
                        color: .green
                    )
                    
                    Spacer()
                    
                    IngredientCount(
                        count: recipe.missedIngredientCount,
                        label: "Ingredients needed",
                        color: .orange
                    )
                }
                .padding(.top, 4)
            }
            .padding()
            .background(Color(.systemBackground))
            .cornerRadius(16)
            .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
        }
    }
}

struct IngredientCount: View {
    let count: Int
    let label: String
    let color: Color
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack(spacing: 6) {
                Image(systemName: color == .green ? "checkmark.circle.fill" : "cart.fill")
                    .foregroundColor(color)
                    .font(.subheadline)
                
                Text("\(count)")
                    .font(.subheadline)
                    .fontWeight(.bold)
                    .foregroundColor(color)
            }
            
            Text(label)
                .font(.caption)
                .foregroundColor(.secondary)
        }
    }
}

struct ProgressBar: View {
    var value: CGFloat // 0.0 to 1.0
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                Rectangle()
                    .frame(width: geometry.size.width, height: geometry.size.height)
                    .opacity(0.2)
                    .foregroundColor(.gray)
                
                Rectangle()
                    .frame(width: min(geometry.size.width * value, geometry.size.width), height: geometry.size.height)
                    .foregroundColor(.green)
            }
            .cornerRadius(10)
            }
    }
}

#Preview {
    SearchView()
}
