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
        AppState(sessionService: SessionServiceImpl())
    }
    var userRecipes = List<RecipeRealm>()
    var user = RemoteUserInfo()
    var searchableRecipes = [Recipe]()
    var sessionService: SessionService
}
