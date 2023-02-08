//
//  AuthInteractor.swift
//  Food_Example
//
//  Created by Артур Кулик on 20.01.2023.
//

import Combine
import FirebaseAuth
import GoogleSignIn

protocol AuthInteractor {
    func signUp(registrationInfo: RegistrationInfo, completion: @escaping (Result<Void, AuthErrorCode>) -> Void)
    func logIn(registrationInfo: RegistrationInfo, completion: @escaping (Result<Void, AuthErrorCode>) -> Void)
    func resetPassword(to email: String, completion: @escaping (Result<Void, AuthErrorCode>) -> Void)
    func logout()
    func signUpWithGoogle()
}

class AuthInteractorImpl: AuthInteractor {
    let authRepository: AuthWebRepository
    var cancelBag = Set<AnyCancellable>()
    
    init(authRepository: AuthWebRepository) {
        self.authRepository = authRepository
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
    
    func logIn(registrationInfo: RegistrationInfo, completion: @escaping (Result<Void, AuthErrorCode>) -> Void) {
        authRepository.logIn(registrationInfo: registrationInfo)
            .sink { result in
                switch result {
                case .failure(let error):
                    print("Registration error \(error) ")
                    completion(.failure(error))
                case .finished:
                    break
                }
            } receiveValue: {
                completion(.success(()))
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
    
    func logout() {
    }
    
    func signUpWithGoogle() {
    }
}

struct StubAuthInteractor: AuthInteractor {
    func signUp(registrationInfo: RegistrationInfo, completion: @escaping (Result<Void, AuthErrorCode>) -> Void) {
    }
    
    func resetPassword(to email: String, completion: @escaping (Result<Void, AuthErrorCode>) -> Void) {
    }
    
    func logIn(registrationInfo: RegistrationInfo, completion: @escaping (Result<Void, AuthErrorCode>) -> Void) {
    }
    
    func logout() {
    }
    
    func signUpWithGoogle() {
    }
}
