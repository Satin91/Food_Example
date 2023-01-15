//
//  ContentView.swift
//  Food_Example
//
//  Created by Артур Кулик on 11.01.2023.
//

import SwiftUI

struct MainScreen: View {
    @ObservedObject var viewModel = MainViewModel()
    
    var body: some View {
        ScrollView(.vertical) {
            VStack {
                recipeCell(viewModel.recipes)
                    .padding()
            }
        }
    }
    
    private func recipeCell(_ recipes: [Recipe]) -> some View {
        VStack(alignment: .leading) {
            ForEach(recipes) { recipe in
                HStack {
                    AsyncImage(url: URL(string: recipe.image)) { image in
                        switch image {
                        case .success(let image):
                            image
                                .resizable()
                                .padding()
                        case .empty:
                            EmptyView()
                        case .failure:
                            EmptyView()
                        @unknown default:
                            EmptyView()
                        }
                    }
                    Text(recipe.title)
                        .foregroundColor(.black)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color.gray)
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
    }
}
