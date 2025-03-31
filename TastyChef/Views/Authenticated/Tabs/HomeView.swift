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
                    
                    // Categories
                    CategoriesView(vm: vm)
                    
                    // Popular Recipes
                    VStack(alignment: .leading, spacing: 16) {
                        SortOptionsView(vm: vm)
                        
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
                                    await vm.changeSortOption(to: .popularity)
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

struct SortOptionsView: View {
    @ObservedObject var vm: HomeViewModel
    @State private var showOptions = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(recipesSectionTitle)
                    .font(.title3)
                    .fontWeight(.bold)
                
                Spacer()
                
                Menu {
                    ForEach(SortOption.allCases) { option in
                        Button(action: {
                            Task {
                                await vm.changeSortOption(to: option)
                            }
                        }) {
                            Label(option.displayName, systemImage: option.icon)
                        }
                    }
                } label: {
                    HStack(spacing: 4) {
                        Text("Sort by: \(vm.currentSortOption.displayName)")
                            .font(.footnote)
                            .foregroundColor(.secondary)
                        
                        Image(systemName: "arrow.up.arrow.down")
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                    .padding(.vertical, 8)
                    .padding(.horizontal, 4)
                    .background(Color(.systemBackground))
                    .cornerRadius(8)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                    )
                }
            }
            .padding(.horizontal)
        }
    }
    
    private var recipesSectionTitle: String {
        switch vm.currentSortOption {
        case .popularity:
            return "Popular Recipes"
        case .healthiness:
            return "Healthy Recipes"
        case .price:
            return "Budget-Friendly Recipes"
        case .time:
            return "Quick & Easy Recipes"
        }
    }
}
