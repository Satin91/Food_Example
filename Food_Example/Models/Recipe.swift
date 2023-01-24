//
//  Recipe.swift
//  Food_Example
//
//  Created by Артур Кулик on 15.01.2023.
//

import Foundation

struct SearchRecipesWrapper: RecipesRequestParams {
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
        case sourceUrl
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
    let sourceUrl: String?
    let summary: String?
    
    init(
        id: Int,
        title: String,
        image: String,
        vegetarian: Bool?,
        vegan: Bool?,
        glutenFree: Bool?,
        dairyFree: Bool?,
        cheap: Bool?,
        veryPopular: Bool?,
        sustainable: Bool?,
        veryHealthy: Bool?,
        lowFodmap: Bool?,
        weightWatcherSmartPoints: Int?,
        gaps: String?,
        preparationMinutes: Int?,
        cookingMinutes: Int?,
        aggregateLikes: Int?,
        healthScore: Int?,
        pricePerServing: Double?,
        extendedIngredients: [ExtendedIngredient]?,
        readyInMinutes: Int?,
        sourceUrl: String?,
        summary: String?
    ) {
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
        self.sourceUrl = sourceUrl
        self.summary = summary
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(Int.self, forKey: .id)
        self.title = try container.decode(String.self, forKey: .title)
        self.image = try container.decode(String.self, forKey: .image)
        self.vegetarian = try container.decodeIfPresent(Bool.self, forKey: .vegetarian)
        self.vegan = try container.decodeIfPresent(Bool.self, forKey: .vegan)
        self.glutenFree = try container.decodeIfPresent(Bool.self, forKey: .glutenFree)
        self.dairyFree = try container.decodeIfPresent(Bool.self, forKey: .dairyFree)
        self.cheap = try container.decodeIfPresent(Bool.self, forKey: .cheap)
        self.veryPopular = try container.decodeIfPresent(Bool.self, forKey: .veryPopular)
        self.sustainable = try container.decodeIfPresent(Bool.self, forKey: .sustainable)
        self.veryHealthy = try container.decodeIfPresent(Bool.self, forKey: .veryHealthy)
        self.lowFodmap = try container.decodeIfPresent(Bool.self, forKey: .lowFodmap)
        self.weightWatcherSmartPoints = try container.decodeIfPresent(Int.self, forKey: .weightWatcherSmartPoints)
        self.gaps = try container.decodeIfPresent(String.self, forKey: .gaps)
        self.preparationMinutes = try container.decodeIfPresent(Int.self, forKey: .preparationMinutes)
        self.cookingMinutes = try container.decodeIfPresent(Int.self, forKey: .cookingMinutes)
        self.aggregateLikes = try container.decodeIfPresent(Int.self, forKey: .aggregateLikes)
        self.healthScore = try container.decodeIfPresent(Int.self, forKey: .healthScore)
        self.pricePerServing = try container.decodeIfPresent(Double.self, forKey: .pricePerServing)
        self.extendedIngredients = try container.decodeIfPresent([ExtendedIngredient].self, forKey: .extendedIngredients)
        self.readyInMinutes = try container.decodeIfPresent(Int.self, forKey: .readyInMinutes)
        self.sourceUrl = try container.decodeIfPresent(String.self, forKey: .sourceUrl)
        self.summary = try container.decodeIfPresent(String.self, forKey: .summary)
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
