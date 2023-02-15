//
//  RecipesDBRepository.swift
//  Food_Example
//
//  Created by Артур Кулик on 13.02.2023.
//

import Combine
import Foundation
import RealmSwift

protocol RecipesDBRepository {
    var storage: Results<UserRealm> { get }
    
    func saveFavoriteRecipeForCurrentUser(recipe: RecipeRealm)
    func saveUserToStorage(userInfo: UserInfo, favoriteRecipes: [Recipe])
}

final class RecipesDBRepositoryImpl: RecipesDBRepository {
    @ObservedResults(UserRealm.self) var storage
    
    init() {
        createStorageIfNeed()
    }
    
    func saveUserToStorage(userInfo: UserInfo, favoriteRecipes: [Recipe]) {
        let userRealm = UserRealm()
        userRealm.name = userInfo.username
        userRealm.email = userInfo.email
        userRealm.favoriteRecipes = convert(recipes: favoriteRecipes)
        $storage.append(userRealm)
    }
    
    func saveFavoriteRecipeForCurrentUser(recipe: RecipeRealm) {
    }
    
    func createNewUser(userInfo: UserInfo) {
        let userRealm = UserRealm()
        userRealm.name = userInfo.username
        userRealm.email = userInfo.email
        $storage.append(userRealm)
    }
    
    func createStorageIfNeed() {
        if storage.isEmpty {
            $storage.append(UserRealm())
        }
    }
    
    func convert(recipes: [Recipe]) -> List<RecipeRealm> {
        let recipesRealm = List<RecipeRealm>()
        recipes.forEach { recipe in
            recipesRealm.append(RecipeRealm(recipe: recipe))
        }
        return recipesRealm
    }
}
