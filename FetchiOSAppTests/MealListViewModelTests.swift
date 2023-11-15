//
//  MealListViewModelTests.swift
//  FetchiOSAppTests
//
//  Created by Victor Ruiz on 11/15/23.
//

import XCTest
@testable import FetchiOSApp

class MealListViewModelTests: XCTestCase {
    private var mockRepository: MockMealRepository!
    private var viewModel: MealListViewModel!

    @MainActor 
    override func setUp() {
        super.setUp()
        mockRepository = MockMealRepository()
        viewModel = MealListViewModel(mealRepository: mockRepository)
    }

    override func tearDown() {
        mockRepository = nil
        viewModel = nil
        super.tearDown()
    }

    @MainActor
    func testFetchDataSuccess() async {
        let meals = [Meal(name: "Test Meal", image: "test", id: "1")]
        mockRepository.fetchMealResult = .success(MealResponse(meals: meals))

        await viewModel.trigger(.fetchData(for: .Dessert))

        XCTAssertEqual(viewModel.meals.count, 1)
        XCTAssertEqual(viewModel.meals.first?.name, "Test Meal")
        XCTAssertFalse(viewModel.isLoading)
        XCTAssertFalse(viewModel.showError)
    }
    
    @MainActor
    func testFetchDataFailure() async {
        mockRepository.fetchMealResult = .failure(BasicError.networkError)

        await viewModel.trigger(.fetchData(for: .Dessert))

        XCTAssertTrue(viewModel.showError)
        XCTAssertNotNil(viewModel.errorMessage)
        XCTAssertFalse(viewModel.isLoading)
        XCTAssertTrue(viewModel.meals.isEmpty)
    }
    
    @MainActor
    func testLoadingState() async {
        let expectation = XCTestExpectation(description: "Fetch data")
        mockRepository.fetchMealResult = .success(MealResponse(meals: []))

        Task {
            await viewModel.trigger(.fetchData(for: .Dessert))
            expectation.fulfill()
        }

        await fulfillment(of: [expectation], timeout: 5.0)
        XCTAssertFalse(viewModel.isLoading)
    }
}
