//
//  MealPlanView.swift
//  TastyChef
//
//  Created by Ahmed Hamza on 3/25/25.
//

import SwiftUI

struct MealPlanView: View {
    @StateObject private var viewModel = MealPlanViewModel(networkManager: NetworkManager())
    
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
                    
                    // Form
                    VStack(spacing: 16) {
                        // Calories
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Target Daily Calories")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                            
                            TextField("Enter calories (e.g., 2000)", text: $viewModel.targetCalories)
                                .keyboardType(.numberPad)
                                .padding()
                                .background(Color(.systemBackground))
                                .cornerRadius(8)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(Color.gray.opacity(0.2), lineWidth: 1)
                                )
                        }
                        
                        // Diet
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Diet Type")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                            
                            Picker("Diet", selection: $viewModel.selectedDiet) {
                                ForEach(viewModel.diets, id: \.self) { diet in
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
                            
                            TextField("Enter ingredients separated by commas", text: $viewModel.excludeIngredients)
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
                    
                    // Generate
                    Button(action: viewModel.generatePlan) {
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
                        .background(viewModel.isFormValid ? Color("colorPrimary") : Color.gray)
                        .foregroundColor(.white)
                        .cornerRadius(12)
                        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
                    }
                    .disabled(viewModel.isLoading || !viewModel.isFormValid)
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
}

#Preview {
    MealPlanView()
}
