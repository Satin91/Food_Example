//
//  UserInfo.swift
//  Food_Example
//
//  Created by Артур Кулик on 19.01.2023.
//

import Foundation
import RealmSwift

final class RemoteUserInfo {
    var uid: String = ""
    var username: String = ""
    var email: String = ""
    var favoriteRecipesIDs = [Int]()
    
    convenience init(uid: String, username: String, email: String, favoriteRecipesIDs: [Int] = [0]) {
        self.init()
        self.uid = uid
        self.username = username
        self.email = email
        self.favoriteRecipesIDs = favoriteRecipesIDs
    }
}
