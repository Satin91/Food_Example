//
//  Recipe.swift
//  Food_Example
//
//  Created by Артур Кулик on 15.01.2023.
//

import Foundation

struct SearchRecipesWrapper: Decodable {
    var results: [Recipe]
}

struct Recipe: Decodable, Identifiable {
    let id: Int
    let title: String
    let image: String
    let vegetarian, vegan, glutenFree, dairyFree: Bool?
    let veryHealthy, cheap, veryPopular, sustainable: Bool?
    let lowFodmap: Bool?
    let weightWatcherSmartPoints: Int?
    let gaps: String?
    let preparationMinutes, cookingMinutes, aggregateLikes, healthScore: Int?
    let pricePerServing: Double?
    let extendedIngredients: [ExtendedIngredient]?
    let readyInMinutes: Int?
    let sourceURL: String?
    let summary: String?
}

struct ExtendedIngredient: Decodable {
    let id: Int
    let aisle, image: String
    let name, nameClean, original, originalName: String
    let amount: Double
    let unit: String
    let meta: [String]
}

enum Consistency: Decodable {
    case liquid
    case solid
}
