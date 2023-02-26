//
//  RemoteRepository.swift
//  Food_Example
//
//  Created by Артур Кулик on 25.02.2023.
//

import Combine
import FirebaseAuth
import FirebaseDatabase
import Foundation
import RealmSwift

typealias FirebaseUserInfo = UserInfo

protocol RemoteRepository {
    func create(user: FirebaseUserInfo)
    func publish(recipe: List<Recipe>, uid: String)
    func fetch(recipes: List<Recipe>)
    func fetch(user: UserInfo) -> Future<RemoteUserInfo, Never>
}

final class RemoteRepositoryImpl: RemoteRepository {
    func publish(recipe: List<Recipe>, uid: String) {
        let publishedValues = ["favoriteRecipes": Array(recipe.map({ $0.recipeId }))]
        Database.userReferenceFrom(uid: uid).updateChildValues(publishedValues)
    }
    
    func fetch(recipes: List<Recipe>) {
    }
    
    func fetch(user: FirebaseUserInfo) -> Future<RemoteUserInfo, Never> {
        Future { promise in
            Database.userReferenceFrom(uid: user.uid).getData { _, snapshot in
                guard let remoteStorageUser = snapshot?.value as? [String: Any] else { return }
                let userInfo = RemoteUserInfo(
                    uid: user.uid,
                    username: remoteStorageUser[UserInfoConfig.username] as! String,
                    email: remoteStorageUser[UserInfoConfig.email] as! String,
                    favoriteRecipesIDs: List<Int>(remoteStorageUser[UserInfoConfig.favoriteRecipes])
                )
                promise(.success(userInfo))
            }
        }
    }
    
    func create(user: FirebaseUserInfo) {
        print("Publish user \(user)")
        let values: [String: Any] = [
            UserInfoConfig.email: user.email,
            UserInfoConfig.username: user.displayName ?? "UserInfo",
            UserInfoConfig.favoriteRecipes: [0]
        ]
        Database.userReferenceFrom(uid: user.uid).updateChildValues(values)
    }
}

enum UserInfoConfig {
    static let email = "email"
    static let username = "username"
    static let favoriteRecipes = "favoriteRecipes"
}
