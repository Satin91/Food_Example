//
//  Food_ExampleApp.swift
//  Food_Example
//
//  Created by Артур Кулик on 11.01.2023.
//

import FirebaseAuth
import FirebaseCore
import SwiftUI

@main
struct FoodExampleApp: App {
    var body: some Scene {
        WindowGroup {
            AppCoordinator()
        }
    }
    
    init() {
        FirebaseApp.configure()
        do {
            try Auth.auth().signOut()
        } catch let error {
            print(error.localizedDescription)
        }
    }
}
