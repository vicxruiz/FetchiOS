//
//  SearchViewModel.swift
//  FetchProject
//
//  Created by Victor Ruiz on 6/19/23.
//

import Foundation
import SwiftUI
/**
 The view model for the MealListViewController.
 This view model is responsible for fetching and managing meal data for the meal list screen.
 */
@MainActor
final class MealListViewModel: ObservableObject {
    enum Input {
        case fetchData(for: MealCategory)
    }
    // MARK: - Properties
    
    private let mealRepository: MealRepository
    
    /**
     Initializes the MealListViewModel.
     - Parameters:
     - mealRepository: The meal repository object used for fetching meal data.
     */
    init(
        mealRepository: MealRepository = MealService()
    ) {
        self.mealRepository = mealRepository
    }
    
    // MARK: - Outputs
    
    @Published var showError: Bool = false
    @Published var errorMessage: String?
    @Published var isLoading: Bool = false
    @Published var meals: [Meal] = []
    
    // MARK: - Inputs
    
    func trigger(_ input: Input) async {
        switch input {
        case .fetchData(for: let category): await fetchMeal(for: category)
        }
    }
    
    // MARK: - Private Methods
    /**
     Fetches the specifed meal
     - Parameters:
     - category: The meal category to fetch
     */
    private func fetchMeal(
        for category: MealCategory
    ) async {
        self.isLoading = true
        do {
            let data = try await mealRepository.fetchMeal(for: category)
            switch data {
            case .success(let success):
                self.meals = success.meals.compactMap { $0 }.sorted { $0.name < $1.name }
            case .failure(let failure):
                self.errorMessage = failure.localizedDescription
                self.showError = true
            }
            self.isLoading = false
        } catch {
            self.isLoading = false
            self.errorMessage = error.localizedDescription
            self.showError = true
        }
    }
}
