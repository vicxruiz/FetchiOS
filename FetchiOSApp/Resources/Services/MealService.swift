//
//  MealService.swift
//  FetchProject
//
//  Created by Victor Ruiz on 11/13/23.
//

import UIKit

protocol MealRepository {
    func fetchMeal(for category: MealCategory) async throws -> Result<MealResponse, Error>
    func fetchMealDetails(for id: String, completion: @escaping (Result<MealDetailResponse, Error>) -> Void)
}

enum MealCategory: String {
    case Dessert
}

/// Meal Service class for handling meal api related tasks.
final class MealService: MealRepository {
    private let baseUrl: String
    
    init() {
        self.baseUrl = Configuration.mealAPIBaseURL
    }
    
    // MARK: - Fetch Meal
    
    /// Fetch meal data
    ///
    /// - Parameters:
    ///   - category: The category of the meal.
    ///   - completion: The completion block that returns the result of the meal data fetch.
    func fetchMeal(for category: MealCategory) async throws -> Result<MealResponse, Error> {
        let urlString = "\(baseUrl)/filter.php?c=\(category.rawValue)"

        guard let url = URL(string: urlString) else {
            print("Invalid Meal URL")
            return .failure(BasicError.networkError)
        }

        let (data, response) = try await URLSession.shared.data(from: url)
        
        if let httpResponse = response as? HTTPURLResponse,
           httpResponse.statusCode != 200 {
            print("Invalid HTTP Response: \(httpResponse.statusCode)")
            return .failure(BasicError.networkError)
        }

        do {
            let mealResponse = try JSONDecoder().decode(MealResponse.self, from: data)
            return .success(mealResponse)
        } catch {
            print("Failed to decode MealResponse: \(error)")
            return .failure(error)
        }
    }
    
    /// Fetch meal detail data
    ///
    /// - Parameters:
    ///   - category: The id of the meal.
    ///   - completion: The completion block that returns the result of the meal detail data fetch.
    func fetchMealDetails(for id: String, completion: @escaping (Result<MealDetailResponse, Error>) -> Void) {
        let urlString = "\(baseUrl)/lookup.php?i=\(id)"

        guard let url = URL(string: urlString) else {
            print("Invalid Meal URL")
            return
        }

        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                completion(.failure(error))
                return
            }

            if let data = data {
                let decoder = JSONDecoder()
                do {
                    let mealDetailData = try decoder.decode(MealDetailResponse.self, from: data)
                    completion(.success(mealDetailData))
                } catch {
                    completion(.failure(error))
                }
            }
        }

        task.resume()
    }
}

