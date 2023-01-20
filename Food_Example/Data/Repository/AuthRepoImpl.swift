//
//  AuthRepoImpl.swift
//  Food_Example
//
//  Created by Артур Кулик on 17.01.2023.
//

import FirebaseAuth
import Foundation

class AuthRepoImpl: AuthRepo {
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
