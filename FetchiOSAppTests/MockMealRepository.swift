//
//  MockMealRepository.swift
//  FetchiOSAppTests
//
//  Created by Victor Ruiz on 11/15/23.
//

import Foundation
import XCTest
@testable import FetchiOSApp

class MockMealRepository: MealRepository {
    func fetchMealDetails(for id: String, completion: @escaping (Result<FetchiOSApp.MealDetailResponse, Error>) -> Void) {
        
    }
    
    var fetchMealResult: Result<MealResponse, Error>?

    func fetchMeal(for category: MealCategory) async throws -> Result<MealResponse, Error> {
        return fetchMealResult ?? .failure(BasicError.networkError)
    }

    // Implement other required methods...
}
