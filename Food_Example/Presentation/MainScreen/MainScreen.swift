//
//  ContentView.swift
//  Food_Example
//
//  Created by Артур Кулик on 11.01.2023.
//

import SwiftUI

struct MainScreen: View {
    @ObservedObject var viewModel = MainViewModel()
    let columns = [
        GridItem(.flexible(), spacing: 0),
        GridItem(.flexible(), spacing: 0)
    ]
    @State var gridWidth: CGFloat = 0
    
    var body: some View {
        ScrollView(.vertical) {
            VStack(spacing: Constants.Spacing.zero) {
                recipesList(viewModel.recipes)
            }
        }
    }
    
    private func recipesList(_ recipes: [Recipe]) -> some View {
        LazyVGrid(columns: columns, spacing: 0) {
            ForEach(recipes) { recipe in
                RecipeGrid(
                    recipe: recipe,
                    action: {
                        print("Action")
                    }, settingsAction: {
                        print("Settings Action")
                    }
                )
                .padding(Constants.Spacing.xs)
            }
        }
        .task {
            await viewModel.getRecipes()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        MainScreen()
            .background(Color.black)
    }
}
