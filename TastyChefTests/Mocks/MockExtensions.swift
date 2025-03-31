//
//  MockExtensions.swift
//  TastyChef
//
//  Created by Ahmed Hamza on 3/31/25.
//
import Foundation
@testable import TastyChef

extension WebServiceError: Equatable {
    public static func == (lhs: WebServiceError, rhs: WebServiceError) -> Bool {
        switch (lhs, rhs) {
        case (.invalidURL, .invalidURL), 
             (.noData, .noData), 
             (.parsingError, .parsingError):
            return true
        case (.invalidResponse(let lhsCode), .invalidResponse(let rhsCode)):
            return lhsCode == rhsCode
        default:
            return false
        }
    }
} 

extension RecipesViewState: Equatable {
    public static func == (lhs: RecipesViewState, rhs: RecipesViewState) -> Bool {
        switch (lhs, rhs) {
        case (.loading, .loading), (.loaded, .loaded), (.empty, .empty):
            return true
        case (.error(let lhsError), .error(let rhsError)):
            return (lhsError as NSError).code == (rhsError as NSError).code
        default:
            return false
        }
    }
}

extension RecipeDetailViewState: Equatable {
    public static func == (lhs: RecipeDetailViewState, rhs: RecipeDetailViewState) -> Bool {
        switch (lhs, rhs) {
        case (.loading, .loading), (.loaded, .loaded), (.empty, .empty):
            return true
        case (.error(let lhsError), .error(let rhsError)):
            return (lhsError as NSError).code == (rhsError as NSError).code
        default:
            return false
        }
    }
} 
