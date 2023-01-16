//
//  AuthRepoImpl.swift
//  Food_Example
//
//  Created by Артур Кулик on 17.01.2023.
//

import FirebaseAuth
import Foundation

class AuthRepoImpl: AuthRepo {
    func signUpWithEmail(email: String, password: String) {
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            print("Result \(authResult)")
            print("error \(error)")
        }
    }
    
    func signUpWithGoogle() {
    }
}
