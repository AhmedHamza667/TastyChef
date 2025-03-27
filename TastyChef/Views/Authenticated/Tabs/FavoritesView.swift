//
//  FavoritesView.swift
//  TastyChef
//
//  Created by Ahmed Hamza on 3/25/25.
//

import SwiftUI
import SDWebImageSwiftUI

struct FavoritesView: View {
    @StateObject private var viewModel = FavoritesViewModel()
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 16) {
                    if viewModel.isLoading {
                        LoadingView()
                    } else if viewModel.favorites.isEmpty {
                        EmptyStateView(message: "Your favorite recipes will appear here")
                    } else {
                        ForEach(viewModel.favorites, id: \.id) { recipe in
                            NavigationLink(destination: RecipeDetailView(recipeId: recipe.id)) {
                                RecipeCardView(recipe: recipe)
                            }
                        }
                    }
                }
                .padding()
            }
            .background(Color(.systemGray6))
            .navigationTitle("Favorites")
            .toolbar {
                if !viewModel.favorites.isEmpty {
                    Button(action: {
                        viewModel.resetAllFavorites()
                    }) {
                        Text("Clear All")
                            .foregroundColor(.red)
                    }
                }
            }
            .refreshable {
                viewModel.loadFavorites()
            }
            .onAppear{
                viewModel.loadFavorites()
            }
        }
    }
}

#Preview {
    FavoritesView()
}
