//
//  Recipe.swift
//  Food_Example
//
//  Created by Артур Кулик on 15.01.2023.
//

import Foundation

struct SearchRecipesWrapper: Decodable {
    var results: [Recipe]
    var value: Int {
        2
    }
}

struct Recipe: Identifiable {
    var id: Int
    var title: String
    var image: String
    var preparationMinutes: Int?
    var cookingMinutes: Int?
    var extendedIngredients: [ExtendedIngredient]?
    var nutrients: Nutritient?
    var ingridients: [Ingredient]?
    var readyInMinutes: Int?
    var sourceUrl: String?
    var summary: String?
    
    init(
        id: Int,
        title: String,
        image: String
    ) {
        self.id = id
        self.title = title
        self.image = image
    }
}

struct ExtendedIngredient: Decodable {
    let id: Int
    let aisle, image: String?
    let name, nameClean, original, originalName: String?
    let amount: Double?
    let unit: String?
    let meta: [String?]
}

struct Nutritient: Decodable {
    enum CodingKeys: String, CodingKey {
        case calories
        case carbs
        case fat
        case protein
    }
    
    var caloriesValue: String
    var carbsValue: String
    var fatValue: String
    var proteinValue: String
    
    var calories: String {
        caloriesValue + " calories"
    }
    
    var carbs: String {
        carbsValue + " carbs"
    }
    
    var fat: String {
        fatValue + " fat"
    }
    
    var protein: String {
        proteinValue + " protein"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.caloriesValue = try container.decode(String.self, forKey: .calories)
        self.carbsValue = try container.decode(String.self, forKey: .carbs)
        self.fatValue = try container.decode(String.self, forKey: .fat)
        self.proteinValue = try container.decode(String.self, forKey: .protein)
    }
}

struct IngredientWrapper: Decodable {
    var ingredients: [Ingredient]
}

struct Ingredient: Decodable {
    let amount: IngredientAmount
    let image: String
    let name: String
    var imageURL: String {
        Constants.API.baseIngredientImageURL + image
    }
    var value: String {
        if Int(exactly: amount.metric.value) != nil {
            return String("\(Int(amount.metric.value)) " + amount.metric.unit)
        } else {
            return String("\(amount.metric.value) " + amount.metric.unit)
        }
    }
}

struct IngredientAmount: Decodable {
    struct Metric: Decodable {
        var unit: String
        var value: Double
    }
    
    var metric: Metric
}

extension Recipe: Decodable {
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case image
        case preparationMinutes
        case cookingMinutes
        case nutrients
        case extendedIngredients
        case ingridients
        case readyInMinutes
        case sourceUrl
        case summary
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(Int.self, forKey: .id)
        self.title = try container.decode(String.self, forKey: .title)
        self.image = try container.decode(String.self, forKey: .image)
        self.preparationMinutes = try container.decodeIfPresent(Int.self, forKey: .preparationMinutes)
        self.cookingMinutes = try container.decodeIfPresent(Int.self, forKey: .cookingMinutes)
        self.extendedIngredients = try container.decodeIfPresent([ExtendedIngredient].self, forKey: .extendedIngredients)
        self.nutrients = try container.decodeIfPresent(Nutritient.self, forKey: .nutrients)
        self.ingridients = try container.decodeIfPresent([Ingredient].self, forKey: .ingridients)
        self.readyInMinutes = try container.decodeIfPresent(Int.self, forKey: .readyInMinutes)
        self.sourceUrl = try container.decodeIfPresent(String.self, forKey: .sourceUrl)
        self.summary = try container.decodeIfPresent(String.self, forKey: .summary)
    }
}

extension Ingredient: Hashable {
    var identifier: String {
        UUID().uuidString
    }
    
    public static func == (lhs: Ingredient, rhs: Ingredient) -> Bool {
        lhs.identifier == rhs.identifier
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(identifier)
    }
}
