//
//  AuthRepoImpl.swift
//  Food_Example
//
//  Created by Артур Кулик on 17.01.2023.
//

import FirebaseAuth
import Foundation

enum AuthError: Error {
    case wrongEmail
    case wrongPassword
}

class AuthRepoImpl: AuthRepo {
    func signUpWithEmail(email: String, password: String, completion: @escaping (Result<AuthDataResult?, AuthError>) -> Void) async throws {
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            if error == nil {
                completion(.success(authResult))
            }
        }
    }

    func signInWithEmail(email: String, password: String, completion: @escaping (Result<AuthDataResult?, AuthError>) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password, completion: { result, error in
            guard error == nil else {
                completion(.failure(.wrongEmail))
                return
            }
            completion(.success(result.self))
        })
    }

    func signUpWithGoogle() {
    }
}
