//
//  RecipeDetailViewModelTests.swift
//  TastyChef
//
//  Created by Ahmed Hamza on 3/31/25.
//

import XCTest
@testable import TastyChef

class RecipeDetailViewModelTests: XCTestCase {
    var recipeDetailViewModel: RecipeDetailViewModel!
    var mockNetworkManager: MockNetworkManager!
    
    override func setUp() {
        super.setUp()
        mockNetworkManager = MockNetworkManager()
        recipeDetailViewModel = RecipeDetailViewModel(networkManager: mockNetworkManager)
    }
    
    override func tearDown() {
        recipeDetailViewModel = nil
        mockNetworkManager = nil
        super.tearDown()
    }
    
    func testInitialState() {
        // Initial state should be empty
        XCTAssertNil(recipeDetailViewModel.recipeDetails)
        XCTAssertNil(recipeDetailViewModel.nutritionLabelHTML)
        XCTAssertEqual(recipeDetailViewModel.viewState, .empty)
    }
    
    func testGetRecipeDetail_Success() async {
        // Given
        let mockDetail = MockRecipeDetail.createMock()
        mockNetworkManager.mockResponse = mockDetail
        
        // When
        await recipeDetailViewModel.getRecipeDetail(recipeId: 123)
        
        // Then
        XCTAssertEqual(recipeDetailViewModel.viewState, .loaded)
        XCTAssertNotNil(recipeDetailViewModel.recipeDetails)
        XCTAssertEqual(recipeDetailViewModel.recipeDetails?.id, 123)
        XCTAssertEqual(recipeDetailViewModel.recipeDetails?.title, "Test Recipe")
        
        // Verify parameters
        XCTAssertEqual(mockNetworkManager.lastParameters?["includeNutrition"], "true")
    }
    
    func testGetRecipeDetail_Error() async {
        // Given
        mockNetworkManager.shouldSucceed = false
        mockNetworkManager.mockError = WebServiceError.invalidResponse(500)
        
        // When
        await recipeDetailViewModel.getRecipeDetail(recipeId: 123)
        
        // Then
        switch recipeDetailViewModel.viewState {
        case .error(let error):
            XCTAssertEqual(error as? WebServiceError, WebServiceError.invalidResponse(500))
        default:
            XCTFail("Expected error state")
        }
    }
    
    // Helper to create mock recipe detail directly in the test
    private func createMockRecipeDetail() -> RecipeDetailModel {
        return RecipeDetailModel(
            id: 123,
            title: "Test Recipe",
            image: "https://example.com/image.jpg",
            readyInMinutes: 30,
            servings: 4,
            sourceUrl: "https://example.com/recipe",
            aggregateLikes: 44,
            sourceName: "https://example.com/recipe",
            vegetarian: true,
            vegan: false,
            glutenFree: true,
            dairyFree: false,
            extendedIngredients: [],
            analyzedInstructions: [],
            nutrition: nil
        )
    }
} 
