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
                .onAppear {
                    FirebaseApp.configure()
                }
        }
    }
}
