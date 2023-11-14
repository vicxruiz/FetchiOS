//
//  MealListView.swift
//  FetchiOSApp
//
//  Created by Victor Ruiz on 11/13/23.
//

import SwiftUI
import Kingfisher

struct MealListView: View {
    @ObservedObject var viewModel = MealListViewModel()
    var body: some View {
        makeBody()
    }
    
    func makeBody() -> some View {
        NavigationView {
            List {
                Section(Strings.Home.desserts) {
                    ForEach(viewModel.meals) { meal in
                        NavigationLink {
                            MealDetailView(meal: meal, viewModel: MealDetailViewModel())
                        } label: {
                            ContentCell(meal: meal)
                        }

                    }
                }
            }
            .onFirstAppear {
                Task {
                    await viewModel.trigger(.fetchData(for: .Dessert))
                }
            }
            .loading(show: $viewModel.isLoading)
            .navigationTitle(Strings.Home.meal)
            .alert(isPresented: $viewModel.showError) {
                Alert(
                    title: Text("Failed to fetch meals"),
                    message: Text(viewModel.errorMessage ?? ""),
                    dismissButton: .default(Text("OK"))
                )
            }
        }
    }
}

struct ContentCell: View {
    let meal: Meal
    var body: some View {
        HStack(spacing: Layout.pd50) {
            KFImage(URL(string: meal.image))
                .resizable()
                .frame(width: Layout.imageSize, height: Layout.imageSize)
                .cornerRadius(Layout.pd50)
            Text(meal.name)
        }
    }
}
