//
//  TabBarView.swift
//  TastyChef
//
//  Created by Ahmed Hamza on 3/25/25.
//

import SwiftUI

struct TabBarView: View {
    @State private var selectedTab = 0
    
    var body: some View {
        TabView(selection: $selectedTab) {
            HomeView()
                .tabItem {
                    VStack {
                        Image(systemName: "house")
                        Text("Home")
                    }
                }
                .tag(0)
            
            SearchView()
                .tabItem {
                    VStack {
                        Image(systemName: "magnifyingglass.circle")
                        Text("Search")
                    }
                }
                .tag(1)
            
            FavoritesView()
                .tabItem {
                    VStack {
                        Image(systemName: "heart.fill")
                        Text("Favorites")
                    }
                }
                .tag(2)
            
            MealPlanView()
                .tabItem {
                    VStack {
                        Image(systemName: "calendar.badge.clock")
                        Text("Meal Plan")
                    }
                }
                .tag(3)
            
            SettingsView()
                .tabItem {
                    VStack {
                        Image(systemName: "gearshape")
                        Text("Settings")
                    }
                }
                .tag(4)
        }
        .tint(Color("colorPrimary"))
        .onAppear {
            // Customize TabBar appearance
            let appearance = UITabBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = .white
            
        }
    }
}


#Preview {
    TabBarView()
}
