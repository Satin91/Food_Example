//
//  SplashScreenViewModel.swift
//  Food_Example
//
//  Created by Артур Кулик on 12.01.2023.
//

import FirebaseAuth
import SwiftUI

class SplashScreenViewModel: ObservableObject {
    @Published var user: User?
    
    init() {
        checkUserAutorization()
    }
    
    func checkUserAutorization() {
        Auth.auth().addStateDidChangeListener { _, user in
            self.user = user
        }
    }
}
