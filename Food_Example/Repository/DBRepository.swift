//
//  RecipesDBRepository.swift
//  Food_Example
//
//  Created by Артур Кулик on 13.02.2023.
//

import Combine
import Foundation
import RealmSwift

protocol DBRepository {
    var storage: Results<UserRealm> { get }
    var currentStorage: UserRealm { get set }
    var currentStorageObject: CurrentValueSubject<UserRealm, Never> { get set }
    
    func loadStorage(userInfo: RemoteUserInfo)
    func save(favoriteRecipes: RealmSwift.List<Recipe>)
    func save(favoriteRecipe: Recipe)
    func saveUserIfNeed(userInfo: RemoteUserInfo)
    func removeFavorite(from index: Int)
}

final class DBRepositoryImpl: DBRepository {
    @ObservedResults(UserRealm.self) var storage
    @ObservedRealmObject var currentStorage = UserRealm()
    var currentStorageObject = CurrentValueSubject<UserRealm, Never>(UserRealm())
    
    init() {
        createStorageIfNeed()
    }
    
    func loadStorage(userInfo: RemoteUserInfo) {
        let storage = storage.first(where: { $0.email == userInfo.email }) ?? storage.first!
        self.currentStorage = storage
        self.currentStorageObject.send(storage)
    }
    
    func saveUserIfNeed(userInfo: RemoteUserInfo) {
        if !storage.contains(where: { $0.email == userInfo.email }) {
            print("Save new user \(userInfo)")
            saveUser(userInfo: userInfo)
            loadStorage(userInfo: userInfo)
        } else {
            loadStorage(userInfo: userInfo)
        }
    }
    func save(favoriteRecipes: RealmSwift.List<Recipe>) {
        realmHelper {
            currentStorageObject.value.favoriteRecipes = favoriteRecipes
        }
    }
    
    func save(favoriteRecipe: Recipe) {
        realmHelper {
            currentStorageObject.value.favoriteRecipes.append(favoriteRecipe)
        }
    }
    
    func createNewUser(userInfo: RemoteUserInfo) {
        let userRealm = UserRealm()
        userRealm.name = userInfo.username
        userRealm.email = userInfo.email
        $storage.append(userRealm)
    }
    
    func removeFavorite(from index: Int) {
        realmHelper {
            currentStorageObject.value.favoriteRecipes.remove(at: index)
        }
    }
    
    func realmHelper(handler: () -> Void) {
        do {
            let realm = try Realm()
            try realm.write {
                handler()
            }
        } catch {
            print("Error realm i,plement")
        }
    }
    
    func createStorageIfNeed() {
        if storage.isEmpty {
            $storage.append(UserRealm())
        }
    }
}

extension DBRepositoryImpl {
    func saveUser(userInfo: RemoteUserInfo) {
        let userRealm = UserRealm()
        userRealm.name = userInfo.username
        userRealm.email = userInfo.email
        $storage.append(userRealm)
    }
}
