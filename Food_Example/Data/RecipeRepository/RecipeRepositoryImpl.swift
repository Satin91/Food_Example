//
//  RecipeRepositoryImpl.swift
//  Food_Example
//
//  Created by Артур Кулик on 15.01.2023.
//

import Foundation

class RecipeRepositoryImpl: RecipeRepository {
    var dataSource: RecipeDataSource
    
    init(dataSource: RecipeDataSource) {
        self.dataSource = dataSource
    }
    
    func getRecipes() async throws -> [Recipe] {
        let recipe = try await dataSource.searchRecipes()
        return recipe
    }
}
