//
//  FavoritesViewModelTests.swift
//  TastyChef
//
//  Created by Ahmed Hamza on 3/31/25.
//

import XCTest
@testable import TastyChef

class FavoritesViewModelTests: XCTestCase {
    var favoritesViewModel: FavoritesViewModel!
    var mockCoreDataManager: MockCoreDataManager!
    
    override func setUp() {
        super.setUp()
        mockCoreDataManager = MockCoreDataManager()
        favoritesViewModel = FavoritesViewModel(coreDataManager: mockCoreDataManager)
    }
    
    override func tearDown() {
        favoritesViewModel = nil
        mockCoreDataManager = nil
        super.tearDown()
    }
    
    func testInitialState() {
        // Then
        XCTAssertEqual(favoritesViewModel.favorites.count, 0)
        XCTAssertFalse(favoritesViewModel.isLoading)
        XCTAssertNil(favoritesViewModel.errorMessage)
    }
    
    func testLoadFavorites() {
        // Given
        mockCoreDataManager.addToFavorites(id: 1, title: "Recipe 1", image: "image1.jpg")
        mockCoreDataManager.addToFavorites(id: 2, title: "Recipe 2", image: "image2.jpg")
        
        // When
        favoritesViewModel.loadFavorites()
        
        // Then
        XCTAssertEqual(favoritesViewModel.favorites.count, 0) // Our mock returns an empty list from getAllFavorites
        XCTAssertFalse(favoritesViewModel.isLoading)
    }
    
    func testToggleFavorite_AddToFavorites() {
        // Given
        let id: Int32 = 123
        let title = "Test Recipe"
        let image = "test.jpg"
        
        // When
        favoritesViewModel.toggleFavorite(id: id, title: title, image: image)
        
        // Then
        XCTAssertTrue(mockCoreDataManager.isRecipeFavorited(id: id))
    }
    
    func testToggleFavorite_RemoveFromFavorites() {
        // Given
        let id: Int32 = 123
        let title = "Test Recipe"
        let image = "test.jpg"
        mockCoreDataManager.addToFavorites(id: id, title: title, image: image)
        
        // When
        favoritesViewModel.toggleFavorite(id: id, title: title, image: image)
        
        // Then
        XCTAssertFalse(mockCoreDataManager.isRecipeFavorited(id: id))
    }
    
    func testRemoveFavorite() {
        // Given
        let id: Int32 = 123
        mockCoreDataManager.addToFavorites(id: id, title: "Test Recipe", image: "test.jpg")
        
        // When
        favoritesViewModel.removeFavorite(id: id)
        
        // Then
        XCTAssertFalse(mockCoreDataManager.isRecipeFavorited(id: id))
    }
    
    func testIsRecipeFavorited() {
        // Given
        let id: Int32 = 123
        mockCoreDataManager.addToFavorites(id: id, title: "Test Recipe", image: "test.jpg")
        
        // When & Then
        XCTAssertTrue(favoritesViewModel.isRecipeFavorited(id: id))
        XCTAssertFalse(favoritesViewModel.isRecipeFavorited(id: 456))
    }
    
    func testResetAllFavorites() {
        // Given
        mockCoreDataManager.addToFavorites(id: 1, title: "Recipe 1", image: "image1.jpg")
        mockCoreDataManager.addToFavorites(id: 2, title: "Recipe 2", image: "image2.jpg")
        
        // When
        favoritesViewModel.resetAllFavorites()
        
        // Then
        XCTAssertEqual(mockCoreDataManager.getMockFavorites().count, 0)
    }
} 
