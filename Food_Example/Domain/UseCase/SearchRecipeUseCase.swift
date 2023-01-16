//
//  SearchRecipeUseCase.swift
//  Food_Example
//
//  Created by Артур Кулик on 15.01.2023.
//

import Foundation

enum SearchRecipeUseCaseError: Error {
    case networkError
    case decodingError
}

protocol GetRecipes {
    func execute() async -> Result<[Recipe], SearchRecipeUseCaseError>
}

struct SearchRecipeUseCase: GetRecipes {
    var repo: RecipeRepo
    
    init(repo: RecipeRepo) {
        self.repo = repo
    }
    
    func execute() async -> Result<[Recipe], SearchRecipeUseCaseError> {
        do {
            let recipes = try await repo.searchRecipes()
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
