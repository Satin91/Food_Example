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
    
    func loadStorage(userInfo: RemoteUserInfo)
    func save(favoriteRecipes: RealmSwift.List<Recipe>, toUser: RemoteUserInfo)
    func saveUserIfNeed(userInfo: RemoteUserInfo)
}

final class DBRepositoryImpl: DBRepository {
    @ObservedResults(UserRealm.self) var storage
    @ObservedRealmObject var currentStorage = UserRealm()
    
    init() {
        //        for (index, user) in storage.enumerated() where user.email == "Example@gmail.com" {
        //        }
        
        createStorageIfNeed()
    }
    
    func loadStorage(userInfo: RemoteUserInfo) {
        self.currentStorage = storage.first(where: { $0.email == userInfo.email }) ?? storage.first!
        print("Current storage \(currentStorage)")
        currentStorage.favoriteRecipes.forEach { rec in
            print("Favorite recipe \(rec.title)")
        }
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
    func save(favoriteRecipes: RealmSwift.List<Recipe>, toUser: RemoteUserInfo) {
        for index in storage.indices where storage[index].email.lowercased() == toUser.email.lowercased() {
            $currentStorage.favoriteRecipes.wrappedValue = favoriteRecipes
        }
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

extension DBRepositoryImpl {
    func saveUser(userInfo: RemoteUserInfo) {
        let userRealm = UserRealm()
        userRealm.name = userInfo.username
        userRealm.email = userInfo.email
        $storage.append(userRealm)
    }
}
