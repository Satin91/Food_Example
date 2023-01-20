//
//  AuthInteractor.swift
//  Food_Example
//
//  Created by Артур Кулик on 20.01.2023.
//

import Combine
import Foundation

protocol AuthInteractor {
    func signUp(registrationInfo: RegistrationInfo, completion: @escaping (Result<Void, AuthError>) -> Void)
    func logIn(registrationInfo: RegistrationInfo, completion: @escaping (Result<Void, AuthError>) -> Void)
    func logout()
    func signUpWithGoogle()
}

struct AuthInteractorImpl: AuthInteractor {
    let authRepository: AuthRepository
    
    init(authRepository: AuthRepository) {
        self.authRepository = authRepository
    }
    
    func signUp(registrationInfo: RegistrationInfo, completion: @escaping (Result<Void, AuthError>) -> Void) {
        let cancelBag = CancelBag()
        authRepository.signUp(info: registrationInfo)
            .print("Repo with")
            .sink { result in
                switch result {
                case .failure:
                    print("FAILURE")
                    completion(.failure(AuthError.wrongPassword))
                default:
                    print("BREAK")
                }
            } receiveValue: {
                print("RECEIVE VALUE")
                completion(.success(()))
            }
            .store(in: cancelBag)
    }
    
    func logIn(registrationInfo: RegistrationInfo, completion: @escaping (Result<Void, AuthError>) -> Void) {
        let cancelBag = CancelBag()
        authRepository.logIn(registrationInfo: registrationInfo)
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
            .store(in: cancelBag)
    }
    
    func logout() {
    }
    
    func signUpWithGoogle() {
    }
}

struct StubAuthInteractor: AuthInteractor {
    func signUp(registrationInfo: RegistrationInfo, completion: @escaping (Result<Void, AuthError>) -> Void) {
    }
    
    func logIn(registrationInfo: RegistrationInfo, completion: @escaping (Result<Void, AuthError>) -> Void) {
    }
    
    func logout() {
    }
    
    func signUpWithGoogle() {
    }
}
