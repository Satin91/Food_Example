//
//  SignUpRepo.swift
//  Food_Example
//
//  Created by Артур Кулик on 16.01.2023.
//

import FirebaseAuth
import Foundation

protocol AuthRepo {
    func signInWithEmail(email: String, password: String, completion: @escaping (Result<AuthDataResult?, AuthError>) -> Void)
    func signUpWithGoogle() async throws
}
