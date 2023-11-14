//
//  MealDetailViewModel.swift
//  FetchProject
//
//  Created by Victor Ruiz on 11/13/23.
//

import Foundation
import Combine

final class MealDetailViewModel: ObservableObject {
    // MARK: - Properties
    
    private let mealRepository: MealRepository
    
    enum Input {
        case fetchDetails(for: Meal)
    }
    
    /**
     Initializes the MealDetailViewModel.
     - Parameters:
     - mealRepository: The meal repository object used for fetching meal data.
     */
    init(
        mealRepository: MealRepository = MealService()
    ) {
        self.mealRepository = mealRepository
    }
    
    @Published var mealDetail: MealDetail?
    @Published var showError: Bool = false
    @Published var errorMessage: String?
    @Published var isLoading: Bool = false

    func trigger(_ input: Input) {
        switch input {
        case .fetchDetails(for: let meal): fetchDetails(for: meal)
        }
    }
    
    // Fetches the meal details from the meal repository for the specified ID.
    private func fetchDetails(for meal: Meal) {
        self.isLoading = true
        mealRepository.fetchMealDetails(for: meal.id) { result in
            switch result {
            case .failure(let error):
                DispatchQueue.main.async {
                    self.errorMessage = error.localizedDescription
                    self.showError = true
                }
            case .success(let mealDetail):
                DispatchQueue.main.async {
                    self.mealDetail = mealDetail.meals.first
                }
            }
            DispatchQueue.main.async {
                self.isLoading = false
            }
        }
    }
}
