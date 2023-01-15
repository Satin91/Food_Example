//
//  GetRecipeUseCase.swift
//  Food_Example
//
//  Created by Артур Кулик on 15.01.2023.
//

import Foundation

enum UseCaseError: Error {
    case networkError
    case decodingError
}

protocol GetRecipes {
    func execute() async -> Result<[Recipe], UseCaseError>
}

struct GetRecipeUseCase: GetRecipes {
    var repo: RecipeRepository
    
    init(repo: RecipeRepository) {
        self.repo = repo
    }
    
    func execute() async -> Result<[Recipe], UseCaseError> {
        do {
            let recipes = try await repo.getRecipes()
            return .success(recipes)
        } catch let error {
            switch error {
            case UseCaseError.decodingError:
                return .failure(.decodingError)
            default:
                return .failure(.networkError)
            }
        }
    }
}
