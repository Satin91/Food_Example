//
//  SearchRecipesUseCase.swift
//  Food_Example
//
//  Created by Артур Кулик on 18.01.2023.
//

import Foundation

enum SearchRecipesUseCaseError: Error {
    case networkError
    case decodingError
}

protocol SearchRecipes {
    func execute(query: String) async -> Result<[Recipe], SearchRecipeUseCaseError>
}

struct SearchRecipesUseCase: SearchRecipes {
    var repo: RecipeRepo
    
    init(repo: RecipeRepo) {
        self.repo = repo
    }
    
    func execute(query: String) async -> Result<[Recipe], SearchRecipeUseCaseError> {
        do {
            let recipes = try await repo.searchRecipesBy(query: query)
            return .success(recipes)
        } catch let error {
            switch error {
            case SearchRecipeUseCaseError.decodingError:
                return .failure(.decodingError)
            default:
                return .failure(.networkError)
            }
        }
    }
}
