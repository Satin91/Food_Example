//
//  RecipeRealm.swift
//  Food_Example
//
//  Created by Артур Кулик on 13.02.2023.
//

import Foundation
import RealmSwift

final class UserRealm: Object, ObjectKeyIdentifiable {
    @Persisted(primaryKey: true) var _id: ObjectId
    @Persisted var userInfo: RemoteUserInfo?
    @Persisted var favoriteRecipes = RealmSwift.List<Recipe>()
}

final class Recipe: Object, ObjectKeyIdentifiable, Identifiable {
    @Persisted(primaryKey: true) var _id: ObjectId
    @Persisted(originProperty: "favoriteRecipes") var storage: LinkingObjects<UserRealm>
    @Persisted var recipeId = Int()
    @Persisted var title = String()
    @Persisted var image = String()
    @Persisted var preparationMinutes = Int()
    @Persisted var cookingMinutes = Int()
    @Persisted var readyInMinutes = Int()
    @Persisted var sourceUrl = String()
    @Persisted var summary = String()
    @Persisted var extendedIngredients = List<ExtendedIngredient>()
    @Persisted var nutrients: Nutrient?
    @Persisted var ingredients = List<Ingredient>()
}

final class ExtendedIngredient: Object, ObjectKeyIdentifiable {
    @Persisted var id = Int()
    @Persisted var aisle: String
    @Persisted var image = ""
    @Persisted var name = ""
    @Persisted var nameClean = ""
    @Persisted var original = ""
    @Persisted var originalName = ""
    @Persisted var amount: Double = 0
    @Persisted var unit = ""
    @Persisted var meta = List<String?>()
}

final class Ingredient: Object, ObjectKeyIdentifiable {
    @Persisted(primaryKey: true) var _id: ObjectId
    @Persisted var amount: IngredientAmount?
    @Persisted var image: String = ""
    @Persisted var name: String = ""
    var imageURL: String {
        Constants.API.baseIngredientImageURL + image
    }
    var value: String {
        if Int(exactly: amount!.metric!.value) != nil {
            return String("\(Int(amount!.metric!.value)) " + amount!.metric!.unit)
        } else {
            return String("\(amount!.metric!.value) " + amount!.metric!.unit)
        }
    }
}

final class IngredientAmount: Object, ObjectKeyIdentifiable, Decodable {
    enum CodingKeys: String, CodingKey {
        case metric
    }
    
    @Persisted(primaryKey: true) var _id: ObjectId
    @Persisted var metric: Metric?
    
    convenience init(from decoder: Decoder) throws {
        self.init()
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self._metric = try container.decode(Persisted<Metric?>.self, forKey: .metric)
    }
}

final class Metric: Object, Decodable {
    @Persisted var unit: String
    @Persisted var value: Double
}

final class Nutrient: Object, ObjectKeyIdentifiable {
    @Persisted(primaryKey: true) var _id: ObjectId
    @Persisted var caloriesValue = String()
    @Persisted var carbsValue = String()
    @Persisted var fatValue = String()
    @Persisted var proteinValue = String()
    
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
}

extension ExtendedIngredient: Decodable {
    enum CodingKeys: String, CodingKey {
        case id
        case aisle
        case image
        case name
        case nameClean
        case original
        case originalName
        case amount
        case unit
        case meta
    }
    
    convenience init(from decoder: Decoder) throws {
        self.init()
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self._id = try container.decodeIfPresent(Persisted<Int>.self, forKey: .id) ?? Persisted<Int>()
        self._aisle = try container.decodeIfPresent(Persisted<String>.self, forKey: .aisle) ?? Persisted<String>()
        self._image = try container.decodeIfPresent(Persisted<String>.self, forKey: .image) ?? Persisted<String>()
        self._name = try container.decodeIfPresent(Persisted<String>.self, forKey: .name) ?? Persisted<String>()
        self._nameClean = try container.decodeIfPresent(Persisted<String>.self, forKey: .nameClean) ?? Persisted<String>()
        self._original = try container.decodeIfPresent(Persisted<String>.self, forKey: .original) ?? Persisted<String>()
        self._originalName = try container.decodeIfPresent(Persisted<String>.self, forKey: .originalName) ?? Persisted<String>()
        self._amount = try container.decodeIfPresent(Persisted<Double>.self, forKey: .amount) ?? Persisted<Double>()
        self._unit = try container.decodeIfPresent(Persisted<String>.self, forKey: .unit) ?? Persisted<String>()
        self._meta = try container.decodeIfPresent(Persisted<List<String?>>.self, forKey: .meta) ?? Persisted<List<String?>>()
    }
}

extension Recipe: Decodable {
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case image
        case preparationMinutes
        case cookingMinutes
        case readyInMinutes
        case sourceUrl
        case summary
        case extendedIngredients
        case nutrients
        case ingredients
    }
    convenience init(from decoder: Decoder) throws {
        self.init()
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self._recipeId = try container.decode(Persisted<Int>.self, forKey: .id)
        self._image = try container.decode(Persisted<String>.self, forKey: .image)
        self._title = try container.decode(Persisted<String>.self, forKey: .title)
        self._preparationMinutes = try container.decodeIfPresent(Persisted<Int>.self, forKey: .preparationMinutes) ?? Persisted<Int>()
        self._cookingMinutes = try container.decodeIfPresent(Persisted<Int>.self, forKey: .cookingMinutes) ?? Persisted<Int>()
        self._readyInMinutes = try container.decodeIfPresent(Persisted<Int>.self, forKey: .readyInMinutes) ?? Persisted<Int>()
        self._sourceUrl = try container.decodeIfPresent(Persisted<String>.self, forKey: .sourceUrl) ?? Persisted<String>()
        self._summary = try container.decodeIfPresent(Persisted<String>.self, forKey: .summary) ?? Persisted<String>()
        self._extendedIngredients = try container.decodeIfPresent(Persisted<List<ExtendedIngredient>>.self, forKey: .extendedIngredients) ?? Persisted<List<ExtendedIngredient>>()
        self._nutrients = try container.decode(Persisted<Nutrient?>.self, forKey: .nutrients)
        self._ingredients = try container.decodeIfPresent(Persisted<List<Ingredient>>.self, forKey: .ingredients) ?? Persisted<List<Ingredient>>()
    }
}

extension Nutrient: Decodable {
    enum CodingKeys: String, CodingKey {
        case calories
        case carbs
        case fat
        case protein
    }
    
    convenience init(from decoder: Decoder) throws {
        self.init()
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self._caloriesValue = try container.decode(Persisted<String>.self, forKey: .calories)
        self._carbsValue = try container.decode(Persisted<String>.self, forKey: .carbs)
        self._fatValue = try container.decode(Persisted<String>.self, forKey: .fat)
        self._proteinValue = try container.decode(Persisted<String>.self, forKey: .protein)
    }
}

extension Ingredient: Decodable {
    enum CodingKeys: String, CodingKey {
        case amount
        case image
        case name
    }
    convenience init(from decoder: Decoder) throws {
        self.init()
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self._amount = try container.decodeIfPresent(Persisted<IngredientAmount?>.self, forKey: .amount)!
        self._image = try container.decode(Persisted<String>.self, forKey: .image)
        self._name = try container.decode(Persisted<String>.self, forKey: .name)
    }
}

struct IngredientWrapper: Decodable {
    var ingredients: List<Ingredient>
}

struct SearchRecipesWrapper: Decodable {
    enum CodingKeys: String, CodingKey {
        case results
        case recipes
    }
    
    var results: RealmSwift.List<Recipe>
    var recipes: RealmSwift.List<Recipe>
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.results = try container.decodeIfPresent(RealmSwift.List<Recipe>.self, forKey: .results) ?? RealmSwift.List<Recipe>()
        self.recipes = try container.decodeIfPresent(RealmSwift.List<Recipe>.self, forKey: .recipes) ?? RealmSwift.List<Recipe>()
    }
}
