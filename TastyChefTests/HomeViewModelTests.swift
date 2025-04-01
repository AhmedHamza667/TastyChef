//
//  HomeViewModelTests.swift
//  TastyChef
//
//  Created by Ahmed Hamza on 3/31/25.
//

import XCTest
import Combine
@testable import TastyChef

class HomeViewModelTests: XCTestCase {
    var homeViewModel: HomeViewModel!
    var mockNetworkManager: MockNetworkManager!
    private var cancellables = Set<AnyCancellable>()
    
    override func setUp() {
        super.setUp()
        mockNetworkManager = MockNetworkManager()
        homeViewModel = HomeViewModel(networkManager: mockNetworkManager)
    }
    
    override func tearDown() {
        cancellables.forEach { $0.cancel() }
        cancellables.removeAll()
        homeViewModel = nil
        mockNetworkManager = nil
        super.tearDown()
    }
    
    func testInitialState() {
        // Initial state should be empty
        XCTAssertEqual(homeViewModel.recipes.count, 0)
        XCTAssertEqual(homeViewModel.viewState, .empty)
        XCTAssertEqual(homeViewModel.currentSortOption, .popularity)
        XCTAssertFalse(homeViewModel.isLoadingMore)
        XCTAssertEqual(homeViewModel.limit, 10)
        XCTAssertEqual(homeViewModel.offset, 0)
    }
    
    func testGetPopularRecipes() async {
        // Given
        let mockResults = MockResult.createMockResults(count: 5)
        let mockModel = MockPopularRecipesModel.createMock(results: mockResults)
        mockNetworkManager.mockResponse = mockModel
        
        // When
        await homeViewModel.getPopularRecipes()
        
        // Then
        XCTAssertEqual(homeViewModel.recipes.count, 5)
        XCTAssertEqual(homeViewModel.viewState, .loaded)
    }
    
    func testGetCuisine() async {
        // Given
        let mockResults = MockResult.createMockResults(count: 3)
        let mockModel = MockPopularRecipesModel.createMock(results: mockResults)
        mockNetworkManager.mockResponse = mockModel
        
        // When
        await homeViewModel.getCuisine(cuisine: "italian")
        
        // Then
        XCTAssertEqual(homeViewModel.recipes.count, 3)
        XCTAssertEqual(homeViewModel.viewState, .loaded)
        
        // Verify parameters
        XCTAssertEqual(mockNetworkManager.lastParameters?["cuisine"], "italian")
    }
    
    func testGetVegetarian() async {
        // Given
        let mockResults = MockResult.createMockResults(count: 2)
        let mockModel = MockPopularRecipesModel.createMock(results: mockResults)
        mockNetworkManager.mockResponse = mockModel
        
        // When
        await homeViewModel.getVegetarian()
        
        // Then
        XCTAssertEqual(homeViewModel.recipes.count, 2)
        XCTAssertEqual(homeViewModel.viewState, .loaded)
        
        // Verify parameters
        XCTAssertEqual(mockNetworkManager.lastParameters?["diet"], "vegetarian")
    }
    
    func testChangeSortOption() async {
        // Given
        let mockResults = MockResult.createMockResults(count: 4)
        let mockModel = MockPopularRecipesModel.createMock(results: mockResults)
        mockNetworkManager.mockResponse = mockModel
        
        // When
        await homeViewModel.changeSortOption(to: .time)
        
        // Then
        XCTAssertEqual(homeViewModel.currentSortOption, .time)
        XCTAssertEqual(mockNetworkManager.lastParameters?["sort"], "time")
    }
    
    func testLoadMore() async {
        // Given
        // First load
        var mockResults = MockResult.createMockResults(count: 5)
        var mockModel = MockPopularRecipesModel.createMock(results: mockResults)
        mockNetworkManager.mockResponse = mockModel
        await homeViewModel.getPopularRecipes()
        XCTAssertEqual(homeViewModel.recipes.count, 5)
        
        // Second load (more items)
        mockResults = MockResult.createMockResults(count: 3).map { result in
            // Create different IDs for new results
            return Result(id: result.id + 100, title: result.title, image: result.image)
        }
        mockModel = MockPopularRecipesModel.createMock(results: mockResults)
        mockNetworkManager.mockResponse = mockModel
        
        // When
        await homeViewModel.loadMore()
        
        // Then
        XCTAssertEqual(homeViewModel.recipes.count, 8)
        XCTAssertEqual(homeViewModel.offset, 10)
        XCTAssertFalse(homeViewModel.isLoadingMore)
    }
    
    func testResetSearch() async {
        // Given
        let mockResults = MockResult.createMockResults(count: 5)
        let mockModel = MockPopularRecipesModel.createMock(results: mockResults)
        mockNetworkManager.mockResponse = mockModel
        await homeViewModel.getPopularRecipes()
        homeViewModel.searchText = "pasta"
        homeViewModel.offset = 20
        
        // When
        await homeViewModel.resetSearch()
        
        // Then
        XCTAssertEqual(homeViewModel.searchText, "")
        XCTAssertEqual(homeViewModel.recipes.count, 0)
        XCTAssertEqual(homeViewModel.offset, 0)
        XCTAssertEqual(homeViewModel.viewState, .empty)
    }
    
    func testErrorHandling() async {
        // Given
        mockNetworkManager.shouldSucceed = false
        mockNetworkManager.mockError = WebServiceError.invalidResponse(404)
        
        // When
        await homeViewModel.getPopularRecipes()
        
        // Then
        switch homeViewModel.viewState {
        case .error(let error):
            XCTAssertEqual(error as? WebServiceError, WebServiceError.invalidResponse(404))
        default:
            XCTFail("Expected error state")
        }
    }
} 
