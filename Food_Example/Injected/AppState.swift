//
//  AppState.swift
//  Food_Example
//
//  Created by Артур Кулик on 20.01.2023.
//

import Foundation
import RealmSwift

struct AppState {
    static var stub: AppState {
        AppState()
    }
    var userRecipes = List<Recipe>()
    var user = RemoteUserInfo()
    var isLoggedIn = false
    var searchableRecipes = List<Recipe>()
}
