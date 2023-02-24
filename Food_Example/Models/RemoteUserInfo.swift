//
//  UserInfo.swift
//  Food_Example
//
//  Created by Артур Кулик on 19.01.2023.
//

import Foundation
import RealmSwift

final class RemoteUserInfo: Object {
    @Persisted var uid: String = ""
    @Persisted var username: String = ""
    @Persisted var email: String = ""
    var favoriteRecipesIDs = [Int]()
    
    convenience init(uid: String, username: String, email: String, favoriteRecipesIDs: [Int]) {
        self.init()
        self.uid = uid
        self.username = username
        self.email = email
        self.favoriteRecipesIDs = favoriteRecipesIDs
    }
}
