//
//  SearchRecipesUseCase.swift
//  Food_Example
//
//  Created by Артур Кулик on 18.01.2023.
//

import Foundation

enum SearchRecipesUseCaseError: Error {
    case recipeNotFound
    case networkError
}

protocol SearchRecipes {
    func execute(query: String) async -> Result<[Recipe], SearchRecipesUseCaseError>
}

struct SearchRecipesUseCase: SearchRecipes {
    var repo: RecipeRepo
    
    init(repo: RecipeRepo) {
        self.repo = repo
    }
    
    func execute(query: String) async -> Result<[Recipe], SearchRecipesUseCaseError> {
        do {
            let recipes = try await repo.searchRecipesBy(query: query)
            return .success(recipes)
        } catch let error {
            switch error {
            case SearchRecipesUseCaseError.recipeNotFound:
                return .failure(.recipeNotFound)
            default:
                return .failure(.networkError)
            }
        }
    }
}
