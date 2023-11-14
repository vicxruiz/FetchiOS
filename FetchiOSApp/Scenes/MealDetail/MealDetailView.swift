//
//  MealDetailView.swift
//  FetchProject
//
//  Created by Victor Ruiz on 11/13/23.
//

import SwiftUI
import Kingfisher

//Detail view presented after user selects meal from list
struct MealDetailView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject private var viewModel: MealDetailViewModel
    let meal: Meal
    
    init(meal: Meal, viewModel: MealDetailViewModel) {
        self.meal = meal
        self.viewModel = viewModel
    }
    
    var body: some View {
        ScrollView {
            VStack {
                if let mealDetail = viewModel.mealDetail {
                    MealDetailInfoView(meal: mealDetail)
                }
            }
            .task {
                viewModel.trigger(.fetchDetails(for: meal))
            }
            .alert(isPresented: $viewModel.showError) {
                Alert(
                    title: Text(Strings.Alert.failedData),
                    message: Text(viewModel.errorMessage ?? ""),
                    dismissButton: .default(Text("OK"))
                )
            }
            .loading(show: $viewModel.isLoading)
            .navigationTitle(meal.name)
            .navigationBarTitleDisplayMode(.large)
        }
    }
}

struct MealDetailInfoView: View {
    enum Constants {
        static let ingredientsBackground = Color.gray.opacity(0.2)
    }
    let meal: MealDetail
    
    var body: some View {
        VStack(alignment: .leading, spacing: Layout.pd50) {
            mealImageView
            instructionsView
            ingredientsView
        }
        .padding(.horizontal, Layout.pd100)
    }
    
    private var mealImageView: some View {
        KFImage(URL(string: meal.strMealThumb))
            .resizable()
            .aspectRatio(contentMode: .fit)
            .cornerRadius(Layout.pd125)
    }
    
    private var instructionsView: some View {
        VStack(alignment: .leading, spacing: Layout.pd50) {
            Text(Strings.MealDetail.instructions)
                .fontWeight(.bold)
            Text(meal.strInstructions)
                .foregroundColor(Color(uiColor: UIColor.darkGray))
        }
    }
    
    private var ingredientsView: some View {
        VStack(alignment: .leading, spacing: Layout.pd50) {
            Text(Strings.MealDetail.ingredients)
                .fontWeight(.bold)
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: Layout.pd50) {
                    ForEach(Array(zip(meal.ingredients, meal.measurements)).indices, id: \.self) { index in
                        let ingredient = meal.ingredients[index]
                        let measurement = meal.measurements[index]
                        if !ingredient.isEmpty {
                            VStack(alignment: .center) {
                                Text("\(ingredient): \(measurement)")
                                    .padding(.vertical, Layout.pd25)
                                    .padding(.horizontal, Layout.pd50)
                                    .background(Constants.ingredientsBackground)
                                    .cornerRadius(Layout.pd25)
                                    .multilineTextAlignment(.center)
                            }
                        }
                    }
                }
                .padding(.horizontal, Layout.pd100)
            }
        }
    }

}
