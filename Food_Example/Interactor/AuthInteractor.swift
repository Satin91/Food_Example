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
    func signUp(registrationInfo: RegistrationInfo, completion: @escaping (Result<Void, AuthErrorCode>) -> Void)
    func logIn(registrationInfo: RegistrationInfo, completion: @escaping (Result<RemoteUserInfo, AuthErrorCode>) -> Void)
    func resetPassword(to email: String, completion: @escaping (Result<Void, AuthErrorCode>) -> Void)
    func logout(completion: @escaping () -> Void)
    func signUpWithGoogle(completion: @escaping (Result<Void, GoogleSignUpError>) -> Void)
}

class AuthInteractorImpl: AuthInteractor {
    let authRepository: AuthWebRepository
    var cancelBag = Set<AnyCancellable>()
    var appState: Store<AppState>
    
    init(authRepository: AuthWebRepository, appState: Store<AppState>) {
        self.authRepository = authRepository
        self.appState = appState
    }
    
    func signUp(registrationInfo: RegistrationInfo, completion: @escaping (Result<Void, AuthErrorCode>) -> Void) {
        authRepository.signUp(info: registrationInfo)
            .sink { result in
                switch result {
                case .failure(let error):
                    completion(.failure(error))
                default:
                    break
                }
            } receiveValue: {
                completion(.success(()))
            }
            .store(in: &cancelBag)
    }
    
    func logIn(registrationInfo: RegistrationInfo, completion: @escaping (Result<RemoteUserInfo, AuthErrorCode>) -> Void) {
        authRepository.logIn(registrationInfo: registrationInfo)
            .sink { result in
                switch result {
                case .failure(let error):
                    completion(.failure(error))
                case .finished:
                    break
                }
            } receiveValue: { user in
                completion(.success(user))
                self.appState.value.user = user
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
    func signUp(registrationInfo: RegistrationInfo, completion: @escaping (Result<Void, AuthErrorCode>) -> Void) {
    }
    
    func resetPassword(to email: String, completion: @escaping (Result<Void, AuthErrorCode>) -> Void) {
    }
    
    func logIn(registrationInfo: RegistrationInfo, completion: @escaping (Result<RemoteUserInfo, AuthErrorCode>) -> Void) {
    }
    
    func logout(completion: @escaping () -> Void) {
    }
    
    func signUpWithGoogle(completion: @escaping (Result<Void, GoogleSignUpError>) -> Void) {
    }
}
