//
//  RecipesDBRepository.swift
//  Food_Example
//
//  Created by Артур Кулик on 13.02.2023.
//

import Combine
import Foundation
import RealmSwift

protocol LocalRepository {
    var realmObjects: Results<UserRealm> { get }
    var storagePublisher: CurrentValueSubject<UserRealm, Never> { get set }
    
    func loadUserStorage(userInfo: RemoteUserInfo)
    func save(favoriteRecipes: RealmSwift.List<Recipe>)
    func save(favoriteRecipe: Recipe)
    func update(user: RemoteUserInfo)
    func saveUserIfNeed(userInfo: RemoteUserInfo)
    func removeFavorite(from index: Int)
}

final class LocalRepositoryImpl: LocalRepository {
    // All of realm objects
    @ObservedResults(UserRealm.self) var realmObjects
    // Current object
    var storagePublisher = CurrentValueSubject<UserRealm, Never>(UserRealm())
    
    init() {
        createStorageIfNeed()
    }
    
    func loadUserStorage(userInfo: RemoteUserInfo) {
        let storage = realmObjects.first(where: { $0.email.lowercased() == userInfo.email.lowercased() }) ?? UserRealm()
        self.storagePublisher.send(storage)
    }
    
    func saveUserIfNeed(userInfo: RemoteUserInfo) {
        if !realmObjects.contains(where: { $0.email.lowercased() == userInfo.email.lowercased() }) {
            saveUser(userInfo: userInfo)
            loadUserStorage(userInfo: userInfo)
        } else {
            loadUserStorage(userInfo: userInfo)
        }
    }
    
    func save(favoriteRecipes: RealmSwift.List<Recipe>) {
        realmTransaction {
            favoriteRecipes.forEach { recipe in
                if !storagePublisher.value.favoriteRecipes.contains(where: { $0.recipeId == recipe.recipeId }) {
                    storagePublisher.value.favoriteRecipes.append(recipe)
                }
            }
        }
    }
    
    func save(favoriteRecipe: Recipe) {
        realmTransaction {
            if !storagePublisher.value.favoriteRecipes.contains(where: { $0.recipeId == favoriteRecipe.recipeId }) {
                storagePublisher.value.favoriteRecipes.append(favoriteRecipe)
            }
        }
    }
    
    func removeFavorite(from index: Int) {
        realmTransaction {
            storagePublisher.value.favoriteRecipes.remove(at: index)
            storagePublisher.send(storagePublisher.value)
        }
    }
    
    func createStorageIfNeed() {
        if realmObjects.isEmpty {
            $realmObjects.append(UserRealm())
        }
    }
    
    func update(user: RemoteUserInfo) {
        realmTransaction {
            storagePublisher.value.username = user.username
            storagePublisher.value.email = user.email
            storagePublisher.value.uid = user.uid
        }
    }
}

extension LocalRepositoryImpl {
    private func saveUser(userInfo: RemoteUserInfo) {
        let userRealm = UserRealm()
        userRealm.uid = userInfo.uid
        userRealm.username = userInfo.username
        userRealm.email = userInfo.email.lowercased()
        $realmObjects.append(userRealm)
    }
    
    private func realmTransaction(handler: () -> Void) {
        do {
            let realm = try Realm()
            try realm.write {
                handler()
            }
        } catch let error {
            print("Error write transaction \(error.localizedDescription)")
        }
    }
}
