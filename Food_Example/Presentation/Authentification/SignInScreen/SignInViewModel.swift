//
//  SignInViewModel.swift
//  Food_Example
//
//  Created by Артур Кулик on 17.01.2023.
//

import FirebaseAuth
import SwiftUI

class SignInViewModel: ObservableObject {
    let signInWithEmailUseCase = SignInWithEmailUseCase(repo: AuthRepoImpl())
    
    func signIn(email: String, password: String, completion: @escaping (Bool) -> Void) {
        signInWithEmailUseCase.execute(email: email, password: password, completion: { result in
            switch result {
            case .success:
                completion(true)
            case .failure:
                completion(false)
            }
        })
    }
}
