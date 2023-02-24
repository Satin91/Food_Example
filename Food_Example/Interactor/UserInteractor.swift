//
//  UserInteractor.swift
//  Food_Example
//
//  Created by Артур Кулик on 21.02.2023.
//

import Combine
import Foundation

protocol UserInteractor {
    func loadUserFromDB(userInfo: RemoteUserInfo)
}

final class UserInteractorImpl: UserInteractor {
    var dbRepository: DBRepository
    var appState: Store<AppState>
    var cancelBag = Set<AnyCancellable>()
    
    init(dbRepository: DBRepository, appState: Store<AppState>) {
        self.dbRepository = dbRepository
        self.appState = appState
        self.appState.sinkToStorage(dbRepository)
    }
    
    func loadUserFromDB(userInfo: RemoteUserInfo) {
        dbRepository.loadStorage(userInfo: userInfo)
        let userInfo = RemoteUserInfo(
            username: dbRepository.currentStorage.name,
            email: dbRepository.currentStorage.email
        )
        dbRepository.loadStorage(userInfo: userInfo)
    }
}

struct StubUserInteractor: UserInteractor {
    func loadUserFromDB(userInfo: RemoteUserInfo) {
    }
}
