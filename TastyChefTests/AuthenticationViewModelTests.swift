//
//  AuthenticationViewModelTests.swift
//  TastyChef
//
//  Created by Ahmed Hamza on 3/31/25.
//

import XCTest
import Combine
@testable import TastyChef

final class AuthenticationViewModelTests: XCTestCase {
    private var mockAuthService: MockAuthenticationService!
    private var mockAuthStateService: MockAuthenticationStateService!
    private var viewModel: AuthenticationViewModel!
    private var cancellables: Set<AnyCancellable>!
    
    override func setUp() {
        super.setUp()
        mockAuthService = MockAuthenticationService()
        mockAuthStateService = MockAuthenticationStateService()
        viewModel = AuthenticationViewModel(authenticationManager: mockAuthService, authenticationStateManager: mockAuthStateService)
        cancellables = []
    }
    
    override func tearDown() {
        mockAuthService = nil
        mockAuthStateService = nil
        viewModel = nil
        cancellables = nil
        super.tearDown()
    }
    
    // MARK: - Initial State Tests
    
    func testInitialState() {
        XCTAssertEqual(viewModel.email, "")
        XCTAssertEqual(viewModel.password, "")
        XCTAssertFalse(viewModel.isFormValid)
        XCTAssertFalse(viewModel.isLoading)
        XCTAssertNil(viewModel.error)
    }
    
    
    func testFormValidation_ValidSignInInput() {
        let expectation = XCTestExpectation(description: "Wait for form validation")
        
        viewModel.email = "test@example.com"
        viewModel.password = "password123"
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            XCTAssertTrue(self.viewModel.isFormValid)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1.0)
    }
    func testFormValidation_InvalidEmail() {
        viewModel.email = "invalid-email"
        viewModel.password = "password123"
        
        XCTAssertFalse(viewModel.isFormValid)
    }
    
    func testFormValidation_EmptyPassword() {
        viewModel.email = "test@example.com"
        viewModel.password = ""
        
        XCTAssertFalse(viewModel.isFormValid)
    }
    

} 
