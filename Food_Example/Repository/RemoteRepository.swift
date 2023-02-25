//
//  RemoteRepository.swift
//  Food_Example
//
//  Created by Артур Кулик on 25.02.2023.
//

import FirebaseDatabase
import Foundation
import RealmSwift

protocol RemoteRepository {
    func publish(recipe: List<Recipe>, uid: String)
    func fetch(recipes: List<Recipe>)
}

final class RemoteRepositoryImpl: RemoteRepository {
    func publish(recipe: List<Recipe>, uid: String) {
        let publishedValues = ["favoriteRecipes": Array(recipe.map({ $0.recipeId }))]
        Database.userReferenceFrom(uid: uid).updateChildValues(publishedValues)
    }
    
    func fetch(recipes: RealmSwift.List<Recipe>) {
    }
}
