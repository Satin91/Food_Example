//
//  AuthRepository.swift
//  Food_Example
//
//  Created by Артур Кулик on 19.01.2023.
//

import Combine
import FirebaseAuth
import FirebaseDatabase
import Foundation

protocol AuthRepository {
    func signUp(info: RegistrationInfo) -> AnyPublisher<Void, AuthErrorCode>
    func logIn(registrationInfo: RegistrationInfo) -> AnyPublisher<Void, AuthErrorCode>
    func resetPassword(to email: String) -> AnyPublisher<Void, AuthErrorCode>
    func logout()
    func signUpWithGoogle()
}

struct AuthRepositoryImpl: AuthRepository {
    func logIn(registrationInfo: RegistrationInfo) -> AnyPublisher<Void, AuthErrorCode> {
        Deferred {
            Future { promise in
                Auth.auth().signIn(withEmail: registrationInfo.email, password: registrationInfo.password) { _, error in
                    if error != nil {
                        promise(.failure(error as! AuthErrorCode))
                    } else {
                        promise(.success(()))
                    }
                }
            }
        }
        .receive(on: RunLoop.main)
        .eraseToAnyPublisher()
    }
    
    func signUp(info: RegistrationInfo) -> AnyPublisher<Void, AuthErrorCode> {
        Deferred {
            Future { promise in
                // Create user
                Auth.auth().createUser(withEmail: info.email, password: info.password) { result, error in
                    guard error == nil else { return promise(.failure(error as! AuthErrorCode)) }
                    guard let uid = result?.user.uid else { return promise(.failure(AuthErrorCode(.userMismatch))) }
                    let values = [
                        "username": info.name,
                        "email": info.email
                    ]
                    // Upload registration data to remote database
                    if let user = result?.user {
                        user.sendEmailVerification()
                        print("Send verification")
                    }
                    
                    Database.userReferenceFrom(uid: uid)
                        .updateChildValues(values) { error, _ in
                            if let error {
                                promise(.failure(error as! AuthErrorCode))
                            } else {
                                promise(.success(()))
                            }
                        }
                }
            }
        }
        .receive(on: RunLoop.main)
        .eraseToAnyPublisher()
    }
    
    func resetPassword(to email: String) -> AnyPublisher<Void, AuthErrorCode> {
        Deferred {
            Future { promise in
                Auth.auth().sendPasswordReset(withEmail: email) { error in
                    if error != nil {
                        guard let error = error as? AuthErrorCode else { return }
                        promise(.failure(error))
                    } else {
                        promise(.success(Void()))
                    }
                }
            }
        }
        .receive(on: RunLoop.main)
        .eraseToAnyPublisher()
    }
    
    func logout() {
    }
    
    func signUpWithGoogle() {
    }
}
