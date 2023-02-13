//
//  RecipeRealm.swift
//  Food_Example
//
//  Created by Артур Кулик on 13.02.2023.
//

import Foundation
import RealmSwift

final class RecipeRealm: Object, Identifiable {
    @Persisted(primaryKey: true) var _id: ObjectId
    @Persisted var recipeId = Int()
    @Persisted var title = String()
    @Persisted var image = String()
    @Persisted var preparationMinutes = Int()
    @Persisted var cookingMinutes = Int()
    @Persisted var readyInMinutes = Int()
    @Persisted var sourceUrl = String()
    @Persisted var summary = String()
    @Persisted var extendedIngredients = List<ExtendedIngredientRealm>()
    @Persisted var nutritients: NutritientRealm?
    @Persisted var ingredients = List<IngredientRealm>()
    
    convenience init(recipe: Recipe) {
        self.init()
        recipeId = recipe.id
        title = recipe.title
        image = recipe.image
        preparationMinutes = recipe.preparationMinutes!
        cookingMinutes = recipe.cookingMinutes!
        readyInMinutes = recipe.readyInMinutes!
        sourceUrl = recipe.sourceUrl!
        summary = recipe.summary!
        let extendedIngredientsArray = List<ExtendedIngredientRealm>()
        for keks in recipe.extendedIngredients! {
            let extItem = ExtendedIngredientRealm(extendedIngredients: keks)
            extendedIngredientsArray.append(extItem)
        }
        extendedIngredients = extendedIngredientsArray
        ingredients = .init()
    }
}

final class ExtendedIngredientRealm: Object, ObjectKeyIdentifiable {
    @Persisted(primaryKey: true) var _id: ObjectId
    @Persisted var recipeId = Int()
    @Persisted var aisle: String
    @Persisted var image = ""
    @Persisted var name = ""
    @Persisted var nameClean = ""
    @Persisted var original = ""
    @Persisted var originalName = ""
    @Persisted var amount: Double = 0
    @Persisted var unit = ""
    @Persisted var meta = List<String?>()
    
    convenience init(extendedIngredients: ExtendedIngredient) {
        self.init()
        recipeId = extendedIngredients.id
        aisle = extendedIngredients.aisle!
        image = extendedIngredients.image!
        name = extendedIngredients.name!
        nameClean = extendedIngredients.nameClean!
        original = extendedIngredients.original!
        originalName = extendedIngredients.originalName!
        amount = extendedIngredients.amount!
        unit = extendedIngredients.unit!
        meta.append(objectsIn: extendedIngredients.meta)
    }
}

final class IngredientRealm: Object, ObjectKeyIdentifiable {
    @Persisted(primaryKey: true) var _id: ObjectId
    @Persisted var value = String()
    
    convenience init(value: String) {
        self.init()
        self.value = value
    }
}

final class NutritientRealm: Object, ObjectKeyIdentifiable {
    @Persisted(primaryKey: true) var _id: ObjectId
    @Persisted var calories = String()
    @Persisted var carbs = String()
    @Persisted var fat = String()
    @Persisted var protein = String()
}
