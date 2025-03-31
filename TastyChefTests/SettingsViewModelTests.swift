//
//  SettingsViewModelTests.swift
//  TastyChef
//
//  Created by Ahmed Hamza on 3/31/25.
//

import XCTest
@testable import TastyChef

class SettingsViewModelTests: XCTestCase {
    var settingsViewModel: SettingsViewModel!
    var mockAuthManager: MockAuthenticationManager!
    var mockAuthStateManager: MockAuthenticationStateManager!
    
    override func setUp() {
        super.setUp()
        mockAuthManager = MockAuthenticationManager()
        mockAuthStateManager = MockAuthenticationStateManager()
        settingsViewModel = SettingsViewModel(authManager: mockAuthManager, authenticationStateManager: mockAuthStateManager)
    }
    
    override func tearDown() {
        settingsViewModel = nil
        mockAuthManager = nil
        mockAuthStateManager = nil
        super.tearDown()
    }
    
    func testInitialState() {
        // When
        // Initialization happens in setUp
        
        // Then
        XCTAssertEqual(settingsViewModel.email, "test@example.com")
        XCTAssertEqual(settingsViewModel.displayName, "Test User")
        XCTAssertEqual(settingsViewModel.selectedEmoji, "👤")
        XCTAssertFalse(settingsViewModel.isLoading)
        XCTAssertFalse(settingsViewModel.showError)
        XCTAssertNil(settingsViewModel.errorMessage)
        XCTAssertFalse(settingsViewModel.showSuccess)
        XCTAssertEqual(settingsViewModel.successMessage, "")
    }
    
    func testLoadUserData_Success() {
        // Given
        mockAuthManager.mockUser = AuthDataModel(
            uid: "test-uid",
            email: "user@example.com",
            displayName: "😎 Cool User",
            photoURL: nil
        )
        
        // When
        settingsViewModel.loadUserData()
        
        // Then
        XCTAssertEqual(settingsViewModel.email, "user@example.com")
        XCTAssertEqual(settingsViewModel.displayName, "Cool User")
        XCTAssertEqual(settingsViewModel.selectedEmoji, "😎")
    }
    
    func testLoadUserData_Error() {
        // Given
        mockAuthManager.shouldSucceed = false
        
        // When
        settingsViewModel.loadUserData()
        
        // Then
        XCTAssertTrue(settingsViewModel.showError)
        XCTAssertNotNil(settingsViewModel.errorMessage)
    }
    
    func testUpdateProfileName_Success() async {
        // Given
        settingsViewModel.displayName = "New Name"
        settingsViewModel.selectedEmoji = "🍕"
        
        // When
        await settingsViewModel.updateProfileName()
        
        // Then
        XCTAssertTrue(mockAuthManager.updateDisplayNameCalled)
        XCTAssertEqual(mockAuthManager.mockUser.displayName, "🍕 New Name")
        XCTAssertTrue(settingsViewModel.showSuccess)
        XCTAssertEqual(settingsViewModel.successMessage, "Profile updated successfully")
        XCTAssertFalse(settingsViewModel.isLoading)
    }
    
    func testUpdateProfileName_EmptyName() async {
        // Given
        settingsViewModel.displayName = "  "  // Empty or whitespace name
        
        // When
        await settingsViewModel.updateProfileName()
        
        // Then
        XCTAssertFalse(mockAuthManager.updateDisplayNameCalled)
        XCTAssertTrue(settingsViewModel.showError)
        XCTAssertEqual(settingsViewModel.errorMessage, "Please enter a valid name")
    }
    
    func testUpdateProfileName_Error() async {
        // Given
        settingsViewModel.displayName = "New Name"
        mockAuthManager.shouldSucceed = false
        
        // When
        await settingsViewModel.updateProfileName()
        
        // Then
        XCTAssertTrue(mockAuthManager.updateDisplayNameCalled)
        XCTAssertTrue(settingsViewModel.showError)
        XCTAssertNotNil(settingsViewModel.errorMessage)
        XCTAssertFalse(settingsViewModel.isLoading)
    }
    
    func testSignOut_Success() {
        // Given
        mockAuthManager.shouldSucceed = true
        
        // When
        settingsViewModel.signOut()
        
        // Then
        XCTAssertTrue(mockAuthManager.signOutCalled)
        XCTAssertTrue(mockAuthStateManager.unAuthenticateCalled)
    }
    
    func testSignOut_Error() {
        // Given
        mockAuthManager.shouldSucceed = false
        
        // When
        settingsViewModel.signOut()
        
        // Then
        XCTAssertTrue(mockAuthManager.signOutCalled)
        XCTAssertFalse(mockAuthStateManager.unAuthenticateCalled)
        XCTAssertTrue(settingsViewModel.showError)
        XCTAssertNotNil(settingsViewModel.errorMessage)
    }
} 
