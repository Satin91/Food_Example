//
//  AuthInteractor.swift
//  Food_Example
//
//  Created by Артур Кулик on 20.01.2023.
//

import Combine
import FirebaseAuth
import GoogleSignIn
import RealmSwift

protocol AuthInteractor {
    func signUp(info: RegistrationInfo, completion: @escaping (Result<Void, AuthErrorCode>) -> Void)
    func logIn(info: RegistrationInfo, completion: @escaping (Result<RemoteUserInfo, AuthErrorCode>) -> Void)
    func resetPassword(to email: String, completion: @escaping (Result<Void, AuthErrorCode>) -> Void)
    func logout(completion: @escaping () -> Void)
    func signUpWithGoogle(completion: @escaping (Result<Void, GoogleSignUpError>) -> Void)
}

class AuthInteractorImpl: AuthInteractor {
    let authRepository: AuthRemoteRepository
    let storageRepository: StorageRepository
    let remoteRepository: RemoteRepository
    
    var cancelBag = Set<AnyCancellable>()
    var appState: Store<AppState>
    
    init(authRepository: AuthRemoteRepository, storageRepository: StorageRepository, remoteRepository: RemoteRepository, appState: Store<AppState>) {
        self.authRepository = authRepository
        self.storageRepository = storageRepository
        self.remoteRepository = remoteRepository
        self.appState = appState
    }
    
    func signUp(info: RegistrationInfo, completion: @escaping (Result<Void, AuthErrorCode>) -> Void) {
        authRepository.signUp(info: info)
            .sink { result in
                switch result {
                case .failure(let error):
                    completion(.failure(error))
                default:
                    break
                }
            } receiveValue: { userInfo in
                self.remoteRepository.create(user: userInfo)
                // publish(user: userInfo)
                //                self.storageRepository.saveUserIfNeed(userInfo: userInfo)
                completion(.success(()))
            }
            .store(in: &cancelBag)
    }
    
    func logIn(info: RegistrationInfo, completion: @escaping (Result<RemoteUserInfo, AuthErrorCode>) -> Void) {
        authRepository.logIn(info: info)
            .sink { result in
                switch result {
                case .failure(let error):
                    completion(.failure(error))
                case .finished:
                    break
                }
            } receiveValue: { user in
                self.remoteRepository.fetch(user: user)
                    .sink { user in
                        print(user)
                    }
                    .store(in: &self.cancelBag)
                completion(.success(RemoteUserInfo()))
            }
            .store(in: &cancelBag)
    }
    
    func resetPassword(to email: String, completion: @escaping (Result<Void, AuthErrorCode>) -> Void) {
        authRepository.resetPassword(to: email)
            .sink { result in
                switch result {
                case .failure(let error):
                    completion(.failure(error))
                case .finished:
                    break
                }
            } receiveValue: {
                completion(.success(Void()))
            }
            .store(in: &cancelBag)
    }
    
    func signUpWithGoogle(completion: @escaping (Result<Void, GoogleSignUpError>) -> Void) {
        authRepository.signUpWithGoogle()
            .sink { _ in
                completion(.failure(GoogleSignUpError.userCancel))
            } receiveValue: { _ in
                completion(.success(Void()))
            }
            .store(in: &cancelBag)
    }
    
    func logout(completion: @escaping () -> Void) {
        authRepository.logout()
            .sink { _ in
                completion()
            }
            .store(in: &cancelBag)
    }
    
    func getUserFavoritesPresets() {
    }
}

struct StubAuthInteractor: AuthInteractor {
    func signUp(info: RegistrationInfo, completion: @escaping (Result<Void, AuthErrorCode>) -> Void) {
    }
    
    func resetPassword(to email: String, completion: @escaping (Result<Void, AuthErrorCode>) -> Void) {
    }
    
    func logIn(info: RegistrationInfo, completion: @escaping (Result<RemoteUserInfo, AuthErrorCode>) -> Void) {
    }
    
    func logout(completion: @escaping () -> Void) {
    }
    
    func signUpWithGoogle(completion: @escaping (Result<Void, GoogleSignUpError>) -> Void) {
    }
}
