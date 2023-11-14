//
//  Constants.swift
//  FetchProject
//
//  Created by Victor Ruiz on 11/13/23.
//

import Foundation

struct Strings {
    enum Errors {
        static let tryAgain = "Please try again."
        static let networkError = "Unable to load data"
    }
    
    enum Home {
        static let meal = "Meals"
        static let desserts = "Desserts"
    }
    
    enum MealDetail {
        static let ingredients = "Ingredients"
        static let instructions = "Instructions"
    }
    
    enum Alert {
        static let failedData = "Failed to fetch data"
    }
}

struct Layout {
    static let cornerRadius = 8
    static let imageSize: CGFloat = 50
    static let pd25: CGFloat = 4
    static let pd50: CGFloat = 8
    static let pd75: CGFloat = 12
    static let pd100: CGFloat = 16
    static let pd125: CGFloat = 20
}

