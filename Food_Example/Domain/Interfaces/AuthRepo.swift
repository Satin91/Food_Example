//
//  SignUpRepo.swift
//  Food_Example
//
//  Created by Артур Кулик on 16.01.2023.
//

import Foundation

protocol AuthRepo {
    func signUpWithEmail(email: String, password: String) async throws
    func signUpWithGoogle() async throws
}
