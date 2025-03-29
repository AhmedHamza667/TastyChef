//
//  SearchComponents.swift
//  TastyChef
//
//  Created by Ahmed Hamza on 3/29/25.
//

import SwiftUI

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
