//
//  NetworkManager.swift
//  TastyChef
//
//  Created by Ahmed Hamza on 3/25/25.
//

import Foundation

protocol NetworkManagerActions{
    func getDataFromWebService<T: Decodable>(url: URL?, modelType: T.Type) async throws -> T
}

class NetworkManager{
    var urlSession: URLSession
    init(urlSession: URLSession = URLSession.shared) {
        self.urlSession = urlSession
    }
}

extension NetworkManager: NetworkManagerActions {
    func getDataFromWebService<T>(url: URL?, modelType: T.Type) async throws -> T where T : Decodable {
        do{
            guard let url = url else{
                throw WebServiceError.invalidURL
            }
//            print("Fetching from \(url)")
            let (data, response) = try await urlSession.data(from: url)
            if response.isValidResponse(){
                let parsedData = try JSONDecoder().decode(modelType, from: data)
                return parsedData
            }
            else{
                throw WebServiceError.invalidResponse((response as? HTTPURLResponse)?.statusCode ?? 0)
            }
        } catch {
            throw error
        }
        
    }
}

extension URLResponse{
    func isValidResponse()->Bool{
        guard let response = self as? HTTPURLResponse else { return false }
        switch response.statusCode{
        case 200...299:
            return true
        default:
            return false
        
        }
        
    }
}
