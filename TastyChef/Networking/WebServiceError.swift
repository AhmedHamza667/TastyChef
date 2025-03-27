//
//  WebServiceError.swift
//  PokemonMVVMR
//
//  Created by Ahmed Hamza on 3/12/25.
//

import Foundation


enum WebServiceError{
    case invalidURL
    case noData
    case parsingError
    case invalidResponse(Int)
}


extension WebServiceError: LocalizedError, Equatable{
    public var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Invalid URL"
        case .noData:
            return "No Data"
        case .parsingError:
            return "Parsing Error"
        case .invalidResponse(let code):
            return "Invalid Response Code: \(code)"
        }
    }
}
