//
//  CoreDataManagerTests.swifr
//  TastyChef
//
//  Created by Ahmed Hamza on 3/31/25.
//

import XCTest
import CoreData
@testable import TastyChef


class CoreDataManagerTests: XCTestCase {
    var coreDataManager: MockCoreDataManager!
    
    override func setUp() {
        super.setUp()
        coreDataManager = MockCoreDataManager()
    }
    
    override func tearDown() {
        coreDataManager.resetAllFavorites()
        coreDataManager = nil
        super.tearDown()
    }
    
    func testAddToFavorites() {
        // Given
        let id: Int32 = 123
        let title = "Test Recipe"
        let image = "http://example.com/image.jpg"
        
        // When
        coreDataManager.addToFavorites(id: id, title: title, image: image)
        
        // Then
        XCTAssertTrue(coreDataManager.isRecipeFavorited(id: id))
        
        let favorites = coreDataManager.getMockFavorites()
        XCTAssertEqual(favorites.count, 1)
        XCTAssertEqual(favorites[0].id, id)
        XCTAssertEqual(favorites[0].title, title)
        XCTAssertEqual(favorites[0].image, image)
    }
    
    func testRemoveFromFavorites() {
        // Given
        let id: Int32 = 123
        coreDataManager.addToFavorites(id: id, title: "Test Recipe", image: "test.jpg")
        XCTAssertTrue(coreDataManager.isRecipeFavorited(id: id))
        
        // When
        coreDataManager.removeFromFavorites(id: id)
        
        // Then
        XCTAssertFalse(coreDataManager.isRecipeFavorited(id: id))
        XCTAssertEqual(coreDataManager.getMockFavorites().count, 0)
    }
    
    func testIsRecipeFavorited() {
        // Given
        let id: Int32 = 123
        
        // When & Then
        XCTAssertFalse(coreDataManager.isRecipeFavorited(id: id))
        
        coreDataManager.addToFavorites(id: id, title: "Test Recipe", image: "test.jpg")
        XCTAssertTrue(coreDataManager.isRecipeFavorited(id: id))
    }
    
    func testGetAllFavorites() {
        // Given
        coreDataManager.addToFavorites(id: 1, title: "Recipe 1", image: "image1.jpg")
        coreDataManager.addToFavorites(id: 2, title: "Recipe 2", image: "image2.jpg")
        coreDataManager.addToFavorites(id: 3, title: "Recipe 3", image: "image3.jpg")
        
        // When
        let favorites = coreDataManager.getMockFavorites()
        
        // Then
        XCTAssertEqual(favorites.count, 3)
        
        // Check sorting (should be alphabetical by title)
        XCTAssertEqual(favorites[0].title, "Recipe 1")
        XCTAssertEqual(favorites[1].title, "Recipe 2")
        XCTAssertEqual(favorites[2].title, "Recipe 3")
    }
    
    func testResetAllFavorites() {
        // Given
        coreDataManager.addToFavorites(id: 1, title: "Recipe 1", image: "image1.jpg")
        coreDataManager.addToFavorites(id: 2, title: "Recipe 2", image: "image2.jpg")
        XCTAssertEqual(coreDataManager.getMockFavorites().count, 2)
        
        // When
        coreDataManager.resetAllFavorites()
        
        // Then
        XCTAssertEqual(coreDataManager.getMockFavorites().count, 0)
    }
} 
