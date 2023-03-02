//
//  UserInteractor.swift
//  Food_Example
//
//  Created by Артур Кулик on 21.02.2023.
//

import Combine
import FirebaseAuth
import Foundation

protocol UserInteractor {
    func loadUserFromDB(userInfo: RemoteUserInfo)
    func updateUser(name: String, email: String, completion: @escaping (AuthErrorCode?) -> Void)
}

final class UserInteractorImpl: UserInteractor {
    var localRepository: LocalRepository
    var remoteRepository: RemoteRepository
    var authRepository: AuthRemoteRepository
    var appState: Store<AppState>
    var cancelBag = Set<AnyCancellable>()
    
    init(localRepository: LocalRepository, remoteRepository: RemoteRepository, authRepository: AuthRemoteRepository, appState: Store<AppState>) {
        self.localRepository = localRepository
        self.remoteRepository = remoteRepository
        self.authRepository = authRepository
        self.appState = appState
        self.appState.sinkToStorage(localRepository)
    }
    
    func updateUser(name: String, email: String, completion: @escaping (AuthErrorCode?) -> Void) {
        var userInfo = appState.value.user
        userInfo.username = name
        userInfo.email = email
        guard email != appState.value.user.email else {
            localRepository.update(user: userInfo)
            appState.value.user = userInfo
            remoteRepository.publish(user: userInfo)
            completion(nil)
            return
        }
        authRepository.updateEmail(email: email)
            .sink { error in
                switch error {
                case .failure(let error):
                    completion(error)
                case .finished:
                    break
                }
            } receiveValue: { _ in
                self.localRepository.update(user: userInfo)
                self.appState.value.user = userInfo
                self.remoteRepository.publish(user: userInfo)
                completion(nil)
            }
            .store(in: &cancelBag)
    }
    
    func loadUserFromDB(userInfo: RemoteUserInfo) {
        localRepository.loadUserStorage(userInfo: userInfo)
    }
}

struct StubUserInteractor: UserInteractor {
    func updateUser(name: String, email: String, completion: @escaping (AuthErrorCode?) -> Void) {
    }
    
    func loadUserFromDB(userInfo: RemoteUserInfo) {
    }
}
