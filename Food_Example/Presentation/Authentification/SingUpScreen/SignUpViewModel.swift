//
//  SignUpViewModel.swift
//  Food_Example
//
//  Created by Артур Кулик on 16.01.2023.
//

import FirebaseAuth
import FirebaseFirestore
import SwiftUI

final class SignUpViewModel: ObservableObject {
    let signUpWithEmailUseCase = SignUpWithEmailUseCase(repo: AuthRepoImpl())
    
    func signUpWithEmail(email: String, password: String, completion: @escaping (Bool) -> Void) {
        Task {
            try await signUpWithEmailUseCase.execute(email: email, password: password, completion: { result in
                switch result {
                case .success:
                    completion(true)
                case .failure:
                    completion(false)
                }
            })
        }
    }
}
