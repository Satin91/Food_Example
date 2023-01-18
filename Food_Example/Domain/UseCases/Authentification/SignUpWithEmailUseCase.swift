//
//  SignUpWithEmailUseCase.swift
//  Food_Example
//
//  Created by Артур Кулик on 17.01.2023.
//

import FirebaseAuth
import Foundation

enum SignUpWithEmailUseCaseError: Error {
    case noConnection
    case wrongEmail
    case notEnoughCharacters
}

protocol SignUp {
    func execute(email: String, password: String, completion: @escaping (Result<AuthDataResult?, AuthError>) -> Void) async throws
}

class SignUpWithEmailUseCase: SignUp {
    var repo: AuthRepo
    
    init(repo: AuthRepo) {
        self.repo = repo
    }
    
    func execute(email: String, password: String, completion: @escaping (Result<AuthDataResult?, AuthError>) -> Void) async throws {
        do {
            try await repo.signUpWithEmail(email: email, password: password, completion: { result in
                switch result {
                case .success(let success):
                    completion(.success(success))
                case .failure(let failure):
                    completion(.failure(failure))
                }
            })
        } catch let error as SignUpWithEmailUseCaseError {
            switch error {
            case .noConnection:
                throw error
            case .wrongEmail:
                throw error
            case .notEnoughCharacters:
                throw error
            }
        }
    }
}
