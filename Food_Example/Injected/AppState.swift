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
                guard let userInfo = user.userInfo else { return }
                self.value.user = userInfo
                self.value.userRecipes = user.favoriteRecipes
            }
            .store(in: &self.value.cancelBag)
    }
}
