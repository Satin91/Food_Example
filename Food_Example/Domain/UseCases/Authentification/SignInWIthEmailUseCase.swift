//
//  SignInWIthEmailUseCase.swift
//  Food_Example
//
//  Created by Артур Кулик on 17.01.2023.
//

import FirebaseAuth
import Foundation

protocol SignIn {
    func execute(email: String, password: String, completion: @escaping (Result<AuthDataResult?, AuthError>) -> Void)
}

class SignInWithEmailUseCase: SignIn {
    var repo: AuthRepo
    
    init(repo: AuthRepo) {
        self.repo = repo
    }
    
    func execute(email: String, password: String, completion: @escaping (Result<AuthDataResult?, AuthError>) -> Void) {
        repo.signInWithEmail(email: email, password: password, completion: { result in
            completion(result)
        })
    }
}
