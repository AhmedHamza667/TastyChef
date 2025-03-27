//
//  RecipeCardView.swift
//  TastyChef
//
//  Created by Ahmed Hamza on 3/25/25.
//

import SwiftUI
import SDWebImageSwiftUI

struct RecipeCardView: View {
    let recipe: Result
    @StateObject private var favoritesVM = FavoritesViewModel()
    var body: some View {
        HStack(spacing: 16) {
            // Recipe Image
            
            WebImage(url: URL(string: recipe.image)) { image in
                image
                    .resizable()
                    .frame(width: 100, height: 100)
                    .cornerRadius(12)
                
            } placeholder: {
                ProgressView()
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(recipe.title)
                    .foregroundStyle(.black)
                    .font(.headline)
                    .lineLimit(4)
                    .multilineTextAlignment(.leading)
                
            }
            
            Spacer()
            
            Button(action: {
                favoritesVM.toggleFavorite(
                    id: Int32(recipe.id),
                    title: recipe.title,
                    image: recipe.image
                )
            }) {
                Image(systemName: favoritesVM.isRecipeFavorited(id: Int32(recipe.id)) ? "heart.fill" : "heart")
                    .foregroundColor(Color("colorPrimary"))
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
    RecipeCardView(recipe: Result(id: 945221, title: "Watching What I Eat: Peanut Butter Banana Oat Breakfast Cookies with Carob / Chocolate Chips", image: "https://img.spoonacular.com/recipes/945221-312x231.jpg"))
}
