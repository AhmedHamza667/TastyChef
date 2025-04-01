//
//  FindByIngredientsViewModelTests.swift
//  TastyChef
//
//  Created by Ahmed Hamza on 3/31/25.
//

import XCTest
import Combine
@testable import TastyChef

final class FindByIngredientsViewModelTests: XCTestCase {
    private var mockNetworkManager: MockNetworkManager!
    private var viewModel: FindByIngredientsViewModel!
    private var cancellables: Set<AnyCancellable>!
    
    override func setUp() {
        super.setUp()
        mockNetworkManager = MockNetworkManager()
        viewModel = FindByIngredientsViewModel(networkManager: mockNetworkManager)
        cancellables = []
    }
    
    override func tearDown() {
        mockNetworkManager = nil
        viewModel = nil
        cancellables = nil
        super.tearDown()
    }
    
    // MARK: - Initial State Tests
    
    func testInitialState() {
        XCTAssertTrue(viewModel.ingredients.isEmpty)
        XCTAssertTrue(viewModel.recipes.isEmpty)
        XCTAssertFalse(viewModel.isLoading)
        XCTAssertFalse(viewModel.showError)
        XCTAssertNil(viewModel.errorMessage)
        XCTAssertFalse(viewModel.searchCompleted)
        XCTAssertTrue(viewModel.showInputSection)
        XCTAssertEqual(viewModel.newIngredient, "")
        XCTAssertEqual(viewModel.recipeCount, 5.0)
        XCTAssertFalse(viewModel.ignorePantry)
    }
    
    // MARK: - Ingredient Management Tests
    
    func testAddIngredient_Success() {
        let ingredient = "tomato"
        viewModel.newIngredient = ingredient
        viewModel.addIngredient()
        
        XCTAssertEqual(viewModel.ingredients.count, 1)
        XCTAssertEqual(viewModel.ingredients.first, ingredient)
        XCTAssertEqual(viewModel.newIngredient, "")
    }
    
    func testAddIngredient_EmptyString() {
        viewModel.newIngredient = ""
        viewModel.addIngredient()
        
        XCTAssertTrue(viewModel.ingredients.isEmpty)
    }
    
    func testAddIngredient_WhitespaceOnly() {
        viewModel.newIngredient = "   "
        viewModel.addIngredient()
        
        XCTAssertTrue(viewModel.ingredients.isEmpty)
    }
    
    func testAddIngredient_TrimWhitespace() {
        viewModel.newIngredient = "  tomato  "
        viewModel.addIngredient()
        
        XCTAssertEqual(viewModel.ingredients.count, 1)
        XCTAssertEqual(viewModel.ingredients.first, "tomato")
    }
    
    func testAddIngredient_Duplicate() {
        viewModel.addSpecificIngredient("chicken")
        viewModel.newIngredient = "chicken"
        
        viewModel.addIngredient()
        
        XCTAssertEqual(viewModel.ingredients.count, 1)
    }
    
    func testDeleteIngredient() {
        // Add ingredients
        viewModel.addSpecificIngredient("cheese")
        viewModel.addSpecificIngredient("tomato")
        XCTAssertEqual(viewModel.ingredients.count, 2)
        
        // Delete the first ingredient
        viewModel.deleteIngredient("cheese")
        
        XCTAssertEqual(viewModel.ingredients.count, 1)
        XCTAssertEqual(viewModel.ingredients[0], "tomato")
    }
    
    func testClearIngredients() {
        // Add ingredients
        viewModel.addSpecificIngredient("butter")
        viewModel.addSpecificIngredient("flour")
        viewModel.addSpecificIngredient("sugar")
        XCTAssertEqual(viewModel.ingredients.count, 3)
        
        // Clear ingredients
        viewModel.clearIngredients()
        
        XCTAssertTrue(viewModel.ingredients.isEmpty)
    }
    
    func testToggleInputSection() {
        XCTAssertTrue(viewModel.showInputSection)
        
        viewModel.toggleInputSection()
        XCTAssertFalse(viewModel.showInputSection)
        
        viewModel.toggleInputSection()
        XCTAssertTrue(viewModel.showInputSection)
    }
    
    func testShowInputSectionWithValue() {
        viewModel.showInputSectionWithValue(false)
        
        XCTAssertFalse(viewModel.showInputSection)
        
        viewModel.showInputSectionWithValue(true)
        
        XCTAssertTrue(viewModel.showInputSection)
    }
    
    // MARK: - Recipe Fetching Tests
    
    func testFetchRecipesByIngredients_Success() async {
        // Set up mock data
        let mockRecipes = [
            RecipeByIngredient(id: 1, title: "Pasta", image: "pasta.jpg", imageType: "jpg", usedIngredientCount: 2, missedIngredientCount: 0, missedIngredients: [], usedIngredients: [], unusedIngredients: [], likes: 100),
            RecipeByIngredient(id: 2, title: "Pizza", image: "pizza.jpg", imageType: "jpg", usedIngredientCount: 1, missedIngredientCount: 1, missedIngredients: [], usedIngredients: [], unusedIngredients: [], likes: 200)
        ]
        mockNetworkManager.mockResponse = mockRecipes
        
        // Call the method
        await viewModel.fetchRecipesByIngredients(ingredient: "tomato,cheese", number: 2, ignorePantry: false)
        
        // Verify results
        XCTAssertEqual(viewModel.recipes.count, 2)
        XCTAssertEqual(viewModel.recipes[0].title, "Pasta")
        XCTAssertEqual(viewModel.recipes[1].title, "Pizza")
        XCTAssertTrue(viewModel.searchCompleted)
        XCTAssertFalse(viewModel.isLoading)
        XCTAssertFalse(viewModel.showError)
        
        // Verify parameters
        XCTAssertEqual(mockNetworkManager.lastParameters?["ingredients"], "tomato,cheese")
        XCTAssertEqual(mockNetworkManager.lastParameters?["number"], "2")
        XCTAssertEqual(mockNetworkManager.lastParameters?["ignorePantry"], "false")
    }
    
    func testFetchRecipesByIngredients_Error() async {
        // Set up mock to fail
        mockNetworkManager.shouldSucceed = false
        mockNetworkManager.mockError = NSError(domain: "TestError", code: 1, userInfo: [NSLocalizedDescriptionKey: "Network error"])
        
        // Call the method
        await viewModel.fetchRecipesByIngredients(ingredient: "invalid", number: 5, ignorePantry: true)
        
        // Verify error handling
        XCTAssertTrue(viewModel.showError)
        XCTAssertNotNil(viewModel.errorMessage)
        XCTAssertFalse(viewModel.isLoading)
        XCTAssertFalse(viewModel.searchCompleted)
    }
    
    func testSearchRecipes_EmptyIngredients() async {
        // Set empty ingredients
        viewModel.ingredients = []
        
        // Call search
        await viewModel.searchRecipes()
        
        // Should not make network call
        XCTAssertFalse(mockNetworkManager.getDataFromWebServiceCalled)
        XCTAssertFalse(viewModel.searchCompleted)
    }
    
    func testSearchRecipes_WithIngredients() async {
        // Set up ingredients and mock response
        viewModel.ingredients = ["tomato", "cheese"]
        mockNetworkManager.mockResponse = [RecipeByIngredient(id: 1, title: "Caprese Salad", image: "caprese.jpg", imageType: "jpg", usedIngredientCount: 2, missedIngredientCount: 0, missedIngredients: [], usedIngredients: [], unusedIngredients: [], likes: 150)]
        viewModel.recipeCount = 3
        viewModel.ignorePantry = true
        
        // Call search
        await viewModel.searchRecipes()
        
        // Verify results
        XCTAssertTrue(mockNetworkManager.getDataFromWebServiceCalled)
        XCTAssertEqual(viewModel.recipes.count, 1)
        XCTAssertEqual(viewModel.recipes[0].title, "Caprese Salad")
        XCTAssertTrue(viewModel.searchCompleted)
        XCTAssertFalse(viewModel.showInputSection)
        
        // Verify parameters
        XCTAssertEqual(mockNetworkManager.lastParameters?["ingredients"], "tomato,cheese")
        XCTAssertEqual(mockNetworkManager.lastParameters?["number"], "3")
        XCTAssertEqual(mockNetworkManager.lastParameters?["ignorePantry"], "true")
    }
    
    func testFetchRecipes_NetworkError() async {
        // Set up mock to fail
        mockNetworkManager.shouldSucceed = false
        mockNetworkManager.mockError = NSError(domain: "TestError", code: 1, userInfo: [NSLocalizedDescriptionKey: "Network error"])
        
        // Add ingredients
        viewModel.ingredients = ["tomato", "onion"]
        
        // Call searchRecipes
        await viewModel.searchRecipes()
        
        // Verify error handling
        XCTAssertTrue(viewModel.recipes.isEmpty)
        XCTAssertNotNil(viewModel.errorMessage)
        XCTAssertFalse(viewModel.isLoading)
        XCTAssertTrue(viewModel.showError)
    }
} 