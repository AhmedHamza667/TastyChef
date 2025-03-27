//
//  PopularDishesModel.swift
//  TastyChef
//
//  Created by Ahmed Hamza on 3/25/25.
//

import Foundation

struct PopularRecipesModel: Decodable{
    let results: [Result]
}

struct Result: Decodable{
    let id: Int
    let title: String
    let image: String
}
