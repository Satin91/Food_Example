//
//  RemoteRepository.swift
//  Food_Example
//
//  Created by Артур Кулик on 25.02.2023.
//

import Combine
import FirebaseDatabase
import Foundation
import RealmSwift

protocol RemoteRepository {
    func publish(user: RemoteUserInfo)
    func publish(recipe: List<Recipe>, uid: String)
    func fetch(recipes: List<Recipe>)
    func fetchUserBy(uid: String) -> Future<RemoteUserInfo, Never>
}

final class RemoteRepositoryImpl: RemoteRepository {
    func publish(recipe: List<Recipe>, uid: String) {
        let value = Array(recipe.map({ $0.recipeId }))
        let publishedValues = ["favoriteRecipes": value]
        Database.userReferenceFrom(uid: uid).updateChildValues(publishedValues)
    }
    
    func fetch(recipes: List<Recipe>) {
    }
    
    func fetchUserBy(uid: String) -> Future<RemoteUserInfo, Never> {
        Future { promise in
            Database.userReferenceFrom(uid: uid).getData { _, snapshot in
                guard let remoteStorageUser = snapshot?.value as? NSDictionary else { return }
                let userInfo = RemoteUserInfo(
                    uid: uid,
                    username: remoteStorageUser[UserInfoConfig.username] as! String,
                    email: remoteStorageUser[UserInfoConfig.email] as! String,
                    favoriteRecipesIDs: (remoteStorageUser[UserInfoConfig.favoriteRecipes] as? [Int]) ?? []
                )
                promise(.success(userInfo))
            }
        }
    }
    
    func publish(user: RemoteUserInfo) {
        print("Create user by uid \(user.uid)")
        let values: [String: Any] = [
            UserInfoConfig.email: user.email,
            UserInfoConfig.username: user.username,
            UserInfoConfig.favoriteRecipes: user.favoriteRecipesIDs.isEmpty ? "" : user.favoriteRecipesIDs
        ]
        Database.userReferenceFrom(uid: user.uid).updateChildValues(values)
    }
}

enum UserInfoConfig {
    static let email = "email"
    static let username = "username"
    static let favoriteRecipes = "favoriteRecipes"
}
