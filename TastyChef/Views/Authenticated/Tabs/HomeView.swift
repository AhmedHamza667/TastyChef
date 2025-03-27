//
//  HomeView.swift
//  TastyChef
//
//  Created by Ahmed Hamza on 3/25/25.
//

import SwiftUI

struct HomeView: View {
    @StateObject var vm = HomeViewModel(networkManager: NetworkManager())
    
 
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    // Search Bar
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.gray)
                        
                        TextField("Search recipes, ingredients, cuisine...", text: $vm.searchText)
                            .autocorrectionDisabled()
                            .autocapitalization(.none)

                        if !vm.searchText.isEmpty {
                            Button(action: {
                                     vm.resetSearch()
                                
                            }) {
                                Image(systemName: "xmark.circle.fill")
                                    .foregroundColor(.gray)
                                    .font(.system(size: 16))
                            }
                            .transition(.scale)
                        }
                    }
                    .padding()
                    .background(Color(.white))
                    .cornerRadius(12)
                    .padding(.horizontal)
                    
                    // Categories Section
                    CategoriesView(vm: vm)
                    
                    // Popular Recipes Section
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Popular Recipes")
                            .font(.title3)
                            .fontWeight(.bold)
                            .padding(.horizontal)
                        
                        // State-based content
                        switch vm.viewState {
                        case .loading:
                            LoadingView()
                                .frame(height: 200)
                        
                        case .loaded:
                            if vm.recipes.isEmpty {
                                EmptyStateView(message: "No recipes found")
                            } else {
                                RecipesListView(
                                    recipes: vm.recipes,
                                        loadMoreAction: {
                                            Task {
                                                await vm.loadMore()
                                            }
                                        },
                                        vm: vm
                                    )
                            }
                        
                        case .error(let error):
                            ErrorView(error: error, retryAction: {
                                Task {
                                    await vm.getPopularRecipes()
                                }
                            })
                        
                        case .empty:
                            EmptyStateView(message: "Start searching for recipes")
                        }
                    }
                    .padding(.horizontal)
                }
                .padding(.vertical)
            }
            .background(Color(.systemGray6))
            .task {
                if vm.recipes.isEmpty {
                    await vm.getPopularRecipes()
                }
            }
            .navigationTitle("TastyChef")
        }
    }
}

struct RecipesListView: View {
    let recipes: [Result]
    let loadMoreAction: () -> Void
    @ObservedObject var vm: HomeViewModel  
    
    var body: some View {
        VStack(spacing: 16) {
            ForEach(recipes, id: \.id) { recipe in
                NavigationLink(destination: RecipeDetailView(recipeId: recipe.id)) {
                    RecipeCardView(recipe: recipe)
                }
            }
            
            if !recipes.isEmpty {
                Button(action: loadMoreAction) {
                    HStack {
                        if vm.isLoadingMore {
                            ProgressView()
                                .tint(.white)
                        } else {
                            Text("Load More")
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color("colorPrimary"))
                    .foregroundColor(.white)
                    .cornerRadius(12)
                }
                .disabled(vm.isLoadingMore)
                .padding(.top, 8)
            }
        }
    }
}

#Preview {
    HomeView()
}

struct CategoriesView: View {
    let categories = [
        ("Popular", "star"),
        ("American", "hamburger"),
        ("Vegetarian", "leaf"),
        ("Mexican", "taco"),
        ("Asian", "noodles"),
        ("Italian", "pizza"),
        ("French", "baguette")
    ]
    var vm: HomeViewModel
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Categories")
                .font(.title2)
                .fontWeight(.bold)
                .padding(.horizontal)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 16) {
                    ForEach(categories, id: \.0) { category in
                        Button {
                            Task {
                                if category.0 == "Popular"{
                                    await vm.getPopularRecipes()
                                } else if category.0 == "Vegetarian" {
                                    await vm.getVegetarian()
                                    
                                } else {
                                    await vm.getCuisine(cuisine: category.0)
                                }
                            }
                        } label: {
                            VStack(spacing: 8) {
                                Image(category.1)
                                    .resizable()
                                    .frame(width: 36, height: 36)
                                    .scaledToFit()
                                Text(category.0)
                                    .foregroundStyle(.black)
                                    .font(.subheadline)
                                    .fontWeight(.medium)
                            }
                        }
                        .frame(width: 100, height: 80)
                        .background(.white)
                        .cornerRadius(12)
                    }
                }
                .padding(.horizontal)
            }
        }
    }
}
