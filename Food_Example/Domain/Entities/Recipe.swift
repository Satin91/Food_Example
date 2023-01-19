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
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case image
        case vegetarian
        case vegan
        case glutenFree
        case dairyFree
        case cheap
        case veryPopular
        case sustainable
        case veryHealthy
        case lowFodmap
        case weightWatcherSmartPoints
        case gaps
        case preparationMinutes
        case cookingMinutes
        case aggregateLikes
        case healthScore
        case pricePerServing
        case extendedIngredients
        case readyInMinutes
        case sourceURL
        case summary
    }
    
    let id: Int
    let title: String
    let image: String
    let vegetarian: Bool?
    let vegan: Bool?
    let glutenFree: Bool?
    let dairyFree: Bool?
    let cheap: Bool?
    let veryPopular: Bool?
    let sustainable: Bool?
    let veryHealthy: Bool?
    let lowFodmap: Bool?
    let weightWatcherSmartPoints: Int?
    let gaps: String?
    let preparationMinutes: Int?
    let cookingMinutes: Int?
    let aggregateLikes: Int?
    let healthScore: Int?
    let pricePerServing: Double?
    let extendedIngredients: [ExtendedIngredient]?
    let readyInMinutes: Int?
    let sourceURL: String?
    let summary: String?
    
    init(id: Int, title: String, image: String, vegetarian: Bool?, vegan: Bool?, glutenFree: Bool?, dairyFree: Bool?, cheap: Bool?, veryPopular: Bool?, sustainable: Bool?, veryHealthy: Bool?, lowFodmap: Bool?, weightWatcherSmartPoints: Int?, gaps: String?, preparationMinutes: Int?, cookingMinutes: Int?, aggregateLikes: Int?, healthScore: Int?, pricePerServing: Double?, extendedIngredients: [ExtendedIngredient]?, readyInMinutes: Int?, sourceURL: String?, summary: String?) {
        self.id = id
        self.title = title
        self.image = image
        self.vegetarian = vegetarian
        self.vegan = vegan
        self.glutenFree = glutenFree
        self.dairyFree = dairyFree
        self.cheap = cheap
        self.veryPopular = veryPopular
        self.sustainable = sustainable
        self.veryHealthy = veryHealthy
        self.lowFodmap = lowFodmap
        self.weightWatcherSmartPoints = weightWatcherSmartPoints
        self.gaps = gaps
        self.preparationMinutes = preparationMinutes
        self.cookingMinutes = cookingMinutes
        self.aggregateLikes = aggregateLikes
        self.healthScore = healthScore
        self.pricePerServing = pricePerServing
        self.extendedIngredients = extendedIngredients
        self.readyInMinutes = readyInMinutes
        self.sourceURL = sourceURL
        self.summary = summary
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(Int.self, forKey: .id)
        self.title = try container.decode(String.self, forKey: .title)
        self.image = try container.decode(String.self, forKey: .image)
        self.vegetarian = try container.decode(Bool.self, forKey: .vegetarian)
        self.vegan = try container.decode(Bool.self, forKey: .vegan)
        self.glutenFree = try container.decode(Bool.self, forKey: .glutenFree)
        self.dairyFree = try container.decode(Bool.self, forKey: .dairyFree)
        self.cheap = try container.decodeIfPresent(Bool.self, forKey: .cheap)
        self.veryPopular = try container.decode(Bool.self, forKey: .veryPopular)
        self.sustainable = try container.decode(Bool.self, forKey: .sustainable)
        self.veryHealthy = try container.decode(Bool.self, forKey: .veryHealthy)
        self.lowFodmap = try container.decode(Bool.self, forKey: .lowFodmap)
        self.weightWatcherSmartPoints = try container.decode(Int.self, forKey: .weightWatcherSmartPoints)
        self.gaps = try container.decode(String.self, forKey: .gaps)
        self.preparationMinutes = try container.decode(Int.self, forKey: .preparationMinutes)
        self.cookingMinutes = try container.decode(Int.self, forKey: .cookingMinutes)
        self.aggregateLikes = try container.decode(Int.self, forKey: .aggregateLikes)
        self.healthScore = try container.decode(Int.self, forKey: .healthScore)
        self.pricePerServing = try container.decode(Double.self, forKey: .pricePerServing)
        self.extendedIngredients = try container.decode([ExtendedIngredient].self, forKey: .extendedIngredients)
        self.readyInMinutes = try container.decode(Int.self, forKey: .readyInMinutes)
        self.sourceURL = try container.decode(String.self, forKey: .sourceURL)
        self.summary = try container.decode(String.self, forKey: .summary)
    }
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
