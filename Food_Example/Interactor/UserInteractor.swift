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
    var dbRepository: LocalRepository
    var authRepository: AuthRemoteRepository
    var appState: Store<AppState>
    var cancelBag = Set<AnyCancellable>()
    
    init(dbRepository: LocalRepository, authRepository: AuthRemoteRepository, appState: Store<AppState>) {
        self.dbRepository = dbRepository
        self.authRepository = authRepository
        self.appState = appState
        self.appState.sinkToStorage(dbRepository)
    }
    
    func loadUserFromDB(userInfo: RemoteUserInfo) {
        dbRepository.loadUserStorage(userInfo: userInfo)
    }
}

struct StubUserInteractor: UserInteractor {
    func loadUserFromDB(userInfo: RemoteUserInfo) {
    }
}
