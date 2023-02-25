//
//  RecipesDBRepository.swift
//  Food_Example
//
//  Created by Артур Кулик on 13.02.2023.
//

import Combine
import Foundation
import RealmSwift

protocol StorageRepository {
    var realmObjects: Results<UserRealm> { get }
    var storagePublisher: CurrentValueSubject<UserRealm, Never> { get set }
    
    func loadUserStorage(userInfo: RemoteUserInfo)
    func save(favoriteRecipes: RealmSwift.List<Recipe>)
    func save(favoriteRecipe: Recipe)
    func saveUserIfNeed(userInfo: RemoteUserInfo)
    func removeFavorite(from index: Int)
}

final class StorageRepositoryImpl: StorageRepository {
    // All of realm objects
    @ObservedResults(UserRealm.self) var realmObjects
    // Current object
    var storagePublisher = CurrentValueSubject<UserRealm, Never>(UserRealm())
    
    init() {
        createStorageIfNeed()
    }
    
    func loadUserStorage(userInfo: RemoteUserInfo) {
        let storage = realmObjects.first(where: { $0.userInfo?.email == userInfo.email }) ?? UserRealm()
        self.storagePublisher.send(storage)
    }
    
    func saveUserIfNeed(userInfo: RemoteUserInfo) {
        if !realmObjects.contains(where: { $0.userInfo?.email == userInfo.email }) {
            saveUser(userInfo: userInfo)
            loadUserStorage(userInfo: userInfo)
        } else {
            loadUserStorage(userInfo: userInfo)
        }
    }
    func save(favoriteRecipes: RealmSwift.List<Recipe>) {
        realmTransaction {
            for recipe in favoriteRecipes where !storagePublisher.value.favoriteRecipes.contains(recipe) {
                storagePublisher.value.favoriteRecipes.append(objectsIn: favoriteRecipes)
            }
        }
    }
    
    func save(favoriteRecipe: Recipe) {
        realmTransaction {
            storagePublisher.value.favoriteRecipes.append(favoriteRecipe)
        }
    }
    
    func removeFavorite(from index: Int) {
        realmTransaction {
            storagePublisher.value.favoriteRecipes.remove(at: index)
        }
    }
    
    func createStorageIfNeed() {
        if realmObjects.isEmpty {
            let user = UserRealm()
            user.userInfo = RemoteUserInfo()
            $realmObjects.append(UserRealm())
        }
    }
}

extension StorageRepositoryImpl {
    private func saveUser(userInfo: RemoteUserInfo) {
        let userRealm = UserRealm()
        userRealm.userInfo = userInfo
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
