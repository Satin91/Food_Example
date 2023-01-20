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

enum AuthError: Error {
    case wrongEmail
    case wrongPassword
    case invalidUid
}

protocol AuthRepository {
    func signUp(info: RegistrationInfo) -> AnyPublisher<Void, Error>
    func logIn(registrationInfo: RegistrationInfo) -> AnyPublisher<Void, AuthError>
    func logout()
    func signUpWithGoogle()
}

struct AuthRepositoryImpl: AuthRepository {
    func logIn(registrationInfo: RegistrationInfo) -> AnyPublisher<Void, AuthError> {
        Deferred {
            Future { promise in
                Auth.auth().signIn(withEmail: registrationInfo.email, password: registrationInfo.password) { _, _ in
                    //  guard error == nil else { return promise(.failure(AuthError.wrongEmail)) }
                    promise(.success(()))
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
    func signUp(info: RegistrationInfo) -> AnyPublisher<Void, Error> {
        Deferred {
            Future { promise in
                // Create user
                
                Auth.auth().createUser(withEmail: info.email, password: info.password) { result, error in
                    promise(.success(()))
                    guard error == nil else { return promise(.failure(error!)) }
                    guard let uid = result?.user.uid else { return promise(.failure(AuthError.invalidUid)) }
                    print("Result repo \(result)")
                    let values = [
                        "username": info.name,
                        "email": info.email
                    ]
                    // Upload registration data to remote database
                    
                    Database.database()
                        .reference()
                        .child("users")
                        .child(uid)
                        .updateChildValues(values) { error, _ in
                            if let error {
                                promise(.failure(error))
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
}
