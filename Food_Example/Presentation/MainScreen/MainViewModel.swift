//
//  MainViewModel.swift
//  Food_Example
//
//  Created by Артур Кулик on 11.01.2023.
//

import SwiftUI

@MainActor
final class MainViewModel: ObservableObject {
    var showRandomRecipesUseCase = ShowRandomRecipesUseCase(repo: RecipeRepoImpl())
    var searchRecipesUseCase = SearchRecipesUseCase(repo: RecipeRepoImpl())
    
    @Published var recipes: [Recipe] = []
    @Published var errorMessage = ""
    @Published var hasError = false
    
    func searchRecipesBy(query: String) {
        
    }
    
    func showRandomRecipes() async {
        errorMessage = ""
        let result = await showRandomRecipesUseCase.execute()
        switch result {
        case .success(let recipes):
            self.recipes = recipes
        case .failure(let error):
            self .recipes = []
            errorMessage = error.localizedDescription
            hasError = true
        }
    }
}
