//
//  AppState.swift
//  Food_Example
//
//  Created by Артур Кулик on 20.01.2023.
//

import Combine
import Foundation
import RealmSwift

struct AppState {
    static var stub: AppState {
        AppState()
    }
    var cancelBag = Set<AnyCancellable>()
    var userRecipes = List<Recipe>()
    var user = RemoteUserInfo()
    var isLoggedIn = false
    var searchableRecipes = List<Recipe>()
}

extension Store<AppState> {
    func sinkToStorage(_ repository: StorageRepository) {
        repository.storagePublisher
            .sink { user in
                self.value.user.uid = user.uid
                self.value.user.username = user.username
                self.value.user.email = user.email
                self.value.userRecipes = user.favoriteRecipes
            }
            .store(in: &self.value.cancelBag)
    }
}
