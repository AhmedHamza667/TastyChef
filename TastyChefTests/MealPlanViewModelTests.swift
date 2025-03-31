//
//  MealPlanViewModelTests.swift
//  TastyChef
//
//  Created by Ahmed Hamza on 3/31/25.
//

import XCTest
import Combine
@testable import TastyChef

class MealPlanViewModelTests: XCTestCase {
    
    var viewModel: MealPlanViewModel!
    var mockNetworkManager: MockNetworkManager!
    private var cancellables = Set<AnyCancellable>()
    
    override func setUp() {
        super.setUp()
        mockNetworkManager = MockNetworkManager()
        viewModel = MealPlanViewModel(networkManager: mockNetworkManager)
    }
    
    override func tearDown() {
        cancellables.forEach { $0.cancel() }
        cancellables.removeAll()
        viewModel = nil
        mockNetworkManager = nil
        super.tearDown()
    }
    
    func testInitialState() {
        XCTAssertEqual(viewModel.targetCalories, "")
        XCTAssertEqual(viewModel.selectedDiet, "None")
        XCTAssertEqual(viewModel.excludeIngredients, "")
        XCTAssertFalse(viewModel.isLoading)
        XCTAssertFalse(viewModel.showError)
        XCTAssertNil(viewModel.errorMessage)
        XCTAssertNil(viewModel.mealPlan)
    }
    
    // MARK: - generatePlan Tests
    
    func testGeneratePlan_ValidCalories() {
        let expectation = XCTestExpectation(description: "Generate plan with valid calories")
        
        // Set up mock meal plan
        let mockMealPlan = MockMealPlan.createMock()
        mockNetworkManager.shouldSucceed = true
        mockNetworkManager.mockResponse = mockMealPlan
        
        // Set input values
        viewModel.targetCalories = "1800"
        viewModel.selectedDiet = "Vegetarian"
        viewModel.excludeIngredients = "shellfish,olives"
        
        // Observe isLoading changes to detect completion
        viewModel.$isLoading
            .dropFirst() // Skip initial value
            .sink { isLoading in
                if !isLoading {
                    expectation.fulfill()
                }
            }
            .store(in: &cancellables)
        
        // Call generatePlan
        viewModel.generatePlan()
        
        wait(for: [expectation], timeout: 1.0)
        
        
        // Verify network call parameters
        XCTAssertNotNil(mockNetworkManager.lastURL)
        XCTAssertTrue(mockNetworkManager.lastURL?.absoluteString.contains("mealplanner/generate") ?? false)
        XCTAssertTrue(mockNetworkManager.lastParameters?["targetCalories"] == "1800")
        XCTAssertTrue(mockNetworkManager.lastParameters?["diet"] == "vegetarian")
        XCTAssertTrue(mockNetworkManager.lastParameters?["exclude"] == "shellfish,olives")
    }
    
    func testGeneratePlan_InvalidCalories() {
        // Set input values
        viewModel.targetCalories = ""
        
        // Call generatePlan
        viewModel.generatePlan()
        
        // Verify results
        XCTAssertNil(viewModel.mealPlan)
        XCTAssertTrue(viewModel.showError)
        XCTAssertEqual(viewModel.errorMessage, "Please enter a valid calorie target")
        
        // Should not make network call
        XCTAssertFalse(mockNetworkManager.getDataFromWebServiceCalled)
    }
    
    func testGeneratePlan_NetworkError() {
        let expectation = XCTestExpectation(description: "Generate plan with network error")
        
        // Set up mock to fail
        mockNetworkManager.shouldSucceed = false
        mockNetworkManager.mockError = NSError(domain: "TestError", code: 1, userInfo: [NSLocalizedDescriptionKey: "Test network error"])
        
        // Set input values
        viewModel.targetCalories = "2000"
        
        // Observe isLoading changes to detect completion
        viewModel.$isLoading
            .dropFirst() // Skip initial value
            .sink { isLoading in
                if !isLoading {
                    expectation.fulfill()
                }
            }
            .store(in: &cancellables)
        
        // Call generatePlan
        viewModel.generatePlan()
        
        wait(for: [expectation], timeout: 1.0)
        
        // Verify results
        XCTAssertNil(viewModel.mealPlan)
        XCTAssertTrue(viewModel.showError)
        XCTAssertNotNil(viewModel.errorMessage)
        XCTAssertFalse(viewModel.isLoading)
    }
    
    
    func testGeneratePlan_NonNumericCalories() {
        // Set input values with non-numeric calories
        viewModel.targetCalories = "abc"
        
        // Call generatePlan
        viewModel.generatePlan()
        
        // Verify results
        XCTAssertNil(viewModel.mealPlan)
        XCTAssertTrue(viewModel.showError)
        XCTAssertEqual(viewModel.errorMessage, "Please enter a valid calorie target")
        
        // Should not make network call
        XCTAssertFalse(mockNetworkManager.getDataFromWebServiceCalled)
    }
    
    func testResetForm() {
        // Given
        viewModel.targetCalories = "2000"
        viewModel.selectedDiet = "Vegetarian"
        viewModel.excludeIngredients = "shellfish, peanuts"
        
        // When
        viewModel.resetForm()
        
        // Then
        XCTAssertEqual(viewModel.targetCalories, "")
        XCTAssertEqual(viewModel.selectedDiet, "None")
        XCTAssertEqual(viewModel.excludeIngredients, "")
    }
    
    func testIsFormValid() {
        // Given - invalid
        viewModel.targetCalories = ""
        
        // Then
        XCTAssertFalse(viewModel.isFormValid)
        
        // Given - invalid (non-numeric)
        viewModel.targetCalories = "abc"
        
        // Then
        XCTAssertFalse(viewModel.isFormValid)
        
        // Given - valid
        viewModel.targetCalories = "2000"
        
        // Then
        XCTAssertTrue(viewModel.isFormValid)
    }
    
    func testClearMealPlan() async {
        // Given
        mockNetworkManager.mockResponse = MockMealPlan.createMock()
        await viewModel.generateMealPlan(targetCalories: 2000, diet: nil, exclude: nil)
        
        // When
        await viewModel.clearMealPlan()
        
        // Then
        XCTAssertNil(viewModel.mealPlan)
        XCTAssertFalse(viewModel.showingPlan)
    }
    
    func testMockPropertiesAreAccessible() {
        // This test verifies that our mock implementation correctly exposes testing properties
        // Given
        mockNetworkManager.shouldSucceed = true
        mockNetworkManager.mockResponse = MockMealPlan.createMock()
        
        // When
        Task {
            try? await mockNetworkManager.getDataFromWebService(url: URL(string: "https://example.com"), modelType: MealPlan.self)
        }
        
        let expectation = XCTestExpectation(description: "Network manager accessed")
        
        // Using DispatchWorkItem to avoid ambiguity
        let workItem = DispatchWorkItem {
            // Then
            XCTAssertTrue(self.mockNetworkManager.getDataFromWebServiceCalled)
            XCTAssertNotNil(self.mockNetworkManager.lastURL)
            expectation.fulfill()
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute: workItem)
        wait(for: [expectation], timeout: 1.0)
    }
} 
