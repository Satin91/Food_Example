//
//  RegistrationService.swift
//  Food_Example
//
//  Created by Артур Кулик on 19.01.2023.
//

import Combine
import FirebaseAuth
import FirebaseDatabase
import Foundation

enum RegistrationError: Error {
    case wrongEmail
    case wrongPassword
    case invalidUid
}

protocol RegistrationRepository {
    func register(details: RegistrationInfo) -> AnyPublisher<Void, Error>
}

final class RegistrationRepositoryImpl: RegistrationRepository {
    func register(details: RegistrationInfo) -> AnyPublisher<Void, Error> {
        Deferred {
            Future { promise in
                // Create user
                
                Auth.auth().createUser(withEmail: details.email, password: details.password) { result, error in
                    guard error == nil else { return promise(.failure(error!)) }
                    guard let uid = result?.user.uid else { return promise(.failure(RegistrationError.invalidUid)) }
                    
                    let values = [
                        "username": details.name,
                        "email": details.email
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
