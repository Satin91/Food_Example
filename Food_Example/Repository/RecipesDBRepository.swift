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
    
    func saveFavoriteRecipeForCurrentUser(recipe: Recipe)
    func saveUserToStorage(userInfo: RemoteUserInfo, favoriteRecipes: List<Recipe>)
}

final class RecipesDBRepositoryImpl: RecipesDBRepository {
    @ObservedResults(UserRealm.self) var storage
    
    init() {
        //        for (index, user) in storage.enumerated() where user.email == "Example@gmail.com" {
        //        }
        createStorageIfNeed()
    }
    
    func saveUserToStorage(userInfo: RemoteUserInfo, favoriteRecipes: List<Recipe>) {
        let userRealm = UserRealm()
        userRealm.name = userInfo.username
        userRealm.email = userInfo.email
        userRealm.favoriteRecipes = favoriteRecipes
        $storage.append(userRealm)
    }
    
    func saveFavoriteRecipeForCurrentUser(recipe: Recipe) {
    }
    
    func createNewUser(userInfo: RemoteUserInfo) {
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
}
