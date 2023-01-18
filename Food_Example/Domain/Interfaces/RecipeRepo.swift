//
//  RecipeRepo.swift
//  Food_Example
//
//  Created by Артур Кулик on 15.01.2023.
//

import Foundation

protocol RecipeRepo {
    func showRandomRecipes() async throws -> [Recipe]
    func searchRecipesBy(query: String) async throws -> [Recipe]
}
