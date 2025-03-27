//
//  MealPlanView.swift
//  TastyChef
//
//  Created by Ahmed Hamza on 3/25/25.
//

import SwiftUI

struct MealPlanView: View {
    @StateObject private var viewModel = MealPlanViewModel(networkManager: NetworkManager())
    @State private var targetCalories: String = ""
    @State private var selectedDiet: String = "None"
    @State private var excludeIngredients: String = ""
    
    let diets = ["None", "Vegetarian", "Vegan", "Gluten Free", "Ketogenic", "Paleo"]
    
    var body: some View {
        NavigationView {
            ZStack {
                Color(.systemGray6)
                    .ignoresSafeArea()
                
                VStack(spacing: 20) {
                    // Header Card
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Create your personal meal plan")
                            .font(.headline)
                        
                        Text("Enter your preferences to generate a weekly plan tailored just for you.")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding()
                    .background(Color(.systemBackground))
                    .cornerRadius(12)
                    .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
                    .padding(.horizontal)
                    
                    // Form Fields
                    VStack(spacing: 16) {
                        // Calories field
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Target Daily Calories")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                            
                            TextField("Enter calories (e.g., 2000)", text: $targetCalories)
                                .keyboardType(.numberPad)
                                .padding()
                                .background(Color(.systemBackground))
                                .cornerRadius(8)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(Color.gray.opacity(0.2), lineWidth: 1)
                                )
                        }
                        
                        // Diet Picker
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Diet Type")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                            
                            Picker("Diet", selection: $selectedDiet) {
                                ForEach(diets, id: \.self) { diet in
                                    Text(diet).tag(diet)
                                }
                            }
                            .pickerStyle(MenuPickerStyle())
                            .padding()
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(Color(.systemBackground))
                            .cornerRadius(8)
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(Color.gray.opacity(0.2), lineWidth: 1)
                            )
                        }
                        
                        // Exclude Ingredients
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Exclude Ingredients")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                            
                            TextField("Enter ingredients separated by commas", text: $excludeIngredients)
                                .padding()
                                .background(Color(.systemBackground))
                                .cornerRadius(8)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(Color.gray.opacity(0.2), lineWidth: 1)
                                )
                        }
                    }
                    .padding(.horizontal)
                    
                    Spacer()
                    
                    // Generate Button
                    Button(action: generatePlan) {
                        HStack {
                            if viewModel.isLoading {
                                ProgressView()
                                    .progressViewStyle(CircularProgressViewStyle())
                                    .tint(.white)
                            } else {
                                Text("Generate Meal Plan")
                                    .fontWeight(.semibold)
                            }
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(targetCalories.isEmpty ? Color.gray : Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(12)
                        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
                    }
                    .disabled(viewModel.isLoading || targetCalories.isEmpty)
                    .padding(.horizontal)
                    .padding(.bottom, 20)
                }
                .padding(.top)
            }
            .navigationTitle("Meal Planner")
            .alert("Error", isPresented: $viewModel.showError) {
                Button("OK", role: .cancel) {}
            } message: {
                Text(viewModel.errorMessage ?? "An error occurred")
            }
            .sheet(isPresented: $viewModel.showingPlan) {
                if let mealPlan = viewModel.mealPlan {
                    WeeklyMealPlanView(mealPlan: mealPlan)
                }
            }
        }
    }
    
    private func generatePlan() {
        guard let calories = Int(targetCalories) else { return }
        
        let diet = selectedDiet == "None" ? nil : selectedDiet.lowercased()
        let exclude = excludeIngredients.isEmpty ? nil : excludeIngredients
            .split(separator: ",")
            .map { $0.trimmingCharacters(in: .whitespaces) }
            .joined(separator: ",")
        
        Task {
            await viewModel.generateMealPlan(
                targetCalories: calories,
                diet: diet,
                exclude: exclude
            )
        }
    }
}

#Preview {
    MealPlanView()
}
