//
//  SearchRecipeUseCase.swift
//  Food_Example
//
//  Created by Артур Кулик on 15.01.2023.
//

import Foundation

enum ShowRandomRecipesUseCaseError: Error {
    case networkError
    case decodingError
}

protocol GetRecipes {
    func execute() async -> Result<[Recipe], ShowRandomRecipesUseCaseError>
}

struct ShowRandomRecipesUseCase: GetRecipes {
    var repo: RecipeRepo
    
    init(repo: RecipeRepo) {
        self.repo = repo
    }
    
    func execute() async -> Result<[Recipe], ShowRandomRecipesUseCaseError> {
        do {
            let recipes = try await repo.showRandomRecipes()
            return .success(recipes)
        } catch let error {
            switch error {
            case ShowRandomRecipesUseCaseError.decodingError:
                return .failure(.decodingError)
            default:
                return .failure(.networkError)
            }
        }
    }
}
