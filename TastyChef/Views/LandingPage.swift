//
//  ContentView.swift
//  TastyChef
//
//  Created by Ahmed Hamza on 3/24/25.
//

import SwiftUI

struct LandingPage: View {
    var body: some View {
        NavigationStack{
            VStack {
                // Image container
                Image("landingPageImg")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(maxWidth: .infinity)
                    .frame(height: 400)
                    .clipped()
                
                // Content area
                VStack(spacing: 24) {
                    Text("Unlock Delicious Recipes Daily")
                        .font(.title)
                        .fontWeight(.bold)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                    
                    Text("Find recipes, save your favorites, and create your own dishes with ease")
                        .font(.body)
                        .fontWeight(.light)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                    
                    
                    // Buttons
                    VStack(spacing: 12) {
                        NavigationLink{
                            SignUpView()
                        } label:{
                            Text("Sign Up")
                                .fontWeight(.bold)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color("colorPrimary"))
                                .foregroundColor(.white)
                                .cornerRadius(10)
                        }
                        
                        
                        NavigationLink{
                            LogInView()
                        } label: {
                            Text("Log In")
                                .fontWeight(.bold)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .foregroundColor(Color("colorPrimary"))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(Color("colorPrimary"), lineWidth: 1)
                                )
                        }
                    }
                    .padding(.horizontal)
                }
                .padding(.vertical, 32)
                
                Spacer()
            }
            .edgesIgnoringSafeArea(.top)

        }
    }
}
#Preview {
    LandingPage()
}
