//
//  RecipeRepository.swift
//  Food_Example
//
//  Created by Артур Кулик on 15.01.2023.
//

import Foundation

protocol RecipeRepository {
    func getRecipes() async throws -> [Recipe]
}
