//
//  SignUpWithEmailUseCase.swift
//  Food_Example
//
//  Created by Артур Кулик on 17.01.2023.
//

import Foundation

enum SignUpWithEmailUseCaseError: Error {
    case noConnection
    case wrongEmail
    case notEnoughCharacters
}

protocol SignUp {
    func execute(email: String, password: String) async throws
}

class SignUpWithEmailUseCase: SignUp {
    var repo: AuthRepo
    
    init(repo: AuthRepo) {
        self.repo = repo
    }
    
    func execute(email: String, password: String) async throws {
        do {
            try await repo.signUpWithEmail(email: email, password: password)
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
