//
//  RecipeDataSource.swift
//  Food_Example
//
//  Created by Артур Кулик on 15.01.2023.
//

import Foundation

protocol RecipeDataSource {
    func searchRecipes() async throws -> [Recipe]
}
