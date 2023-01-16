//
//  RecipeRepo.swift
//  Food_Example
//
//  Created by Артур Кулик on 15.01.2023.
//

import Foundation

protocol RecipeRepo {
    func searchRecipes() async throws -> [Recipe]
}
