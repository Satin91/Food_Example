//
//  AppState.swift
//  Food_Example
//
//  Created by Артур Кулик on 20.01.2023.
//

import Combine
import Foundation
import RealmSwift
import SwiftUI

struct AppState {
    static var stub: AppState {
        AppState()
    }
    var cancelBag = Set<AnyCancellable>()
    var userRecipes = RealmSwift.List<Recipe>()
    var user = RemoteUserInfo()
    var searchableRecipes = RealmSwift.List<Recipe>()
}

extension Store<AppState> {
    func sinkToStorage(_ repository: LocalRepository) {
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
