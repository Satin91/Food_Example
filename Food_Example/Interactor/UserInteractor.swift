//
//  UserInteractor.swift
//  Food_Example
//
//  Created by Артур Кулик on 21.02.2023.
//

import Foundation

protocol UserInteractor {
    func loadUserFromDB(userInfo: RemoteUserInfo)
}

final class UserInteractorImpl: UserInteractor {
    var dbRepository: DBRepository
    var appState: Store<AppState>
    
    init(dbRepository: DBRepository, appState: Store<AppState>) {
        self.dbRepository = dbRepository
        self.appState = appState
    }
    
    func loadUserFromDB(userInfo: RemoteUserInfo) {
        dbRepository.loadStorage(userInfo: userInfo)
        let userInfo = RemoteUserInfo(
            username: dbRepository.currentStorage.name,
            email: dbRepository.currentStorage.email
        )
        appState.value.userRecipes = dbRepository.currentStorage.favoriteRecipes
        appState.value.user = userInfo
    }
}

struct StubUserInteractor: UserInteractor {
    func loadUserFromDB(userInfo: RemoteUserInfo) {
    }
}
