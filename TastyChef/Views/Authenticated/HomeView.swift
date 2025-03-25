//
//  HomeView.swift
//  TastyChef
//
//  Created by Ahmed Hamza on 3/25/25.
//

import SwiftUI

struct HomeView: View {
    @State private var searchText = ""
    
    // Sample data
    let categories = [
        ("Fast Food", "hamburger"),
        ("Vegetarian", "leaf"),
        ("Asian", "noodles"),
        ("Italian", "pizza"),
        ("French", "baguette"),
    ]
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                // Search Bar
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.gray)
                    
                    TextField("Search recipes, ingredients, cuisine...", text: $searchText)
                }
                .padding()
                .background(Color(.white))
                .cornerRadius(12)
                .padding(.horizontal)
                
                // Categories Section
                VStack(alignment: .leading, spacing: 16) {
                    Text("Categories")
                        .font(.title2)
                        .fontWeight(.bold)
                        .padding(.horizontal)
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 16) {
                            ForEach(categories, id: \.0) { category in
                                Button{
                                    print(category.0)
                                } label:{
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
                
                // Popular Recipes Section
                VStack(alignment: .leading, spacing: 16) {
                    Text("Popular Recipes")
                        .font(.title3)
                        .fontWeight(.bold)
                        .padding(.horizontal)
                    
                    // Recipe Card
                    RecipeCard(
                        title: "Spaghetti Carbonara",
                        cuisine: "Italian",
                        duration: "30 mins",
                        rating: 4.8,
                        isFavorite: false
                    )
                    .padding(.horizontal)
                }
            }
            .padding(.vertical)
        }
        .background(Color(.systemGray6))

    }
    
}

// Recipe Card Component
struct RecipeCard: View {
    let title: String
    let cuisine: String
    let duration: String
    let rating: Double
    let isFavorite: Bool
    
    var body: some View {
        HStack(spacing: 16) {
            // Recipe Image
            Image("spaghetti_carbonara") // Add this image to your assets
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 100, height: 100)
                .cornerRadius(12)
            
            // Recipe Details
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.headline)
                
                HStack {
                    Text(cuisine)
                    Text("•")
                    Text(duration)
                }
                .font(.subheadline)
                .foregroundColor(.gray)
                
                HStack {
                    Image(systemName: "star.fill")
                        .foregroundColor(.yellow)
                    Text(String(format: "%.1f", rating))
                        .fontWeight(.medium)
                }
            }
            
            Spacer()
            
            // Favorite Button
            Button(action: {
                // Toggle favorite
            }) {
                Image(systemName: isFavorite ? "heart.fill" : "heart")
                    .foregroundColor(isFavorite ? .red : Color("colorPrimary"))
                    .font(.title2)
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
    }
}


#Preview {
    HomeView()
}
