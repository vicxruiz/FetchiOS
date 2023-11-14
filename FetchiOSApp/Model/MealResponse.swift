//
//  MealResponse.swift
//  FetchProject
//
//  Created by Victor Ruiz on 11/13/23.
//

import Foundation

struct MealResponse: Codable {
    let meals: [Meal]
}

struct Meal: Codable, Identifiable {
    let name: String
    let image: String
    let id: String
    
    enum CodingKeys: String, CodingKey {
        case name = "strMeal"
        case image = "strMealThumb"
        case id = "idMeal"
    }
}
