//
//  Configuration.swift
//  FetchProject
//
//  Created by Victor Ruiz on 11/13/23.
//

import Foundation

/// Configuration struct holding base URL for meal API
struct Configuration {
    /// Base URL for meal API.
    static var mealAPIBaseURL: String {
        return "https://themealdb.com/api/json/v1/1/"
    }
}
