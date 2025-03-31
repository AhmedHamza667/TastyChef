//
//  MockFavRecipe.swift
//  TastyChef
//
//  Created by Ahmed Hamza on 3/31/25.
//
import Foundation

class MockFavRecipe {
    var id: Int32
    var title: String?
    var image: String?
    
    init(id: Int32, title: String?, image: String?) {
        self.id = id
        self.title = title
        self.image = image
    }
} 
