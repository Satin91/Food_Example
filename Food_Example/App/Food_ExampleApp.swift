//
//  Food_ExampleApp.swift
//  Food_Example
//
//  Created by Артур Кулик on 11.01.2023.
//

import FirebaseAuth
import FirebaseCore
import GoogleSignIn
import SwiftUI

@main
struct FoodExampleApp: App {
    let parser = HTMLParser()
    var body: some Scene {
        WindowGroup {
            AppCoordinator()
        }
    }
    
    init() {
        FirebaseApp.configure()
        parser.getExcerpt(text: RecipeMock().summary)
        // For develop
        do {
            try Auth.auth().signOut()
        } catch let error {
            print(error.localizedDescription)
        }
    }
}

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey: Any] = [:]) -> Bool {
        GIDSignIn.sharedInstance.handle(url)
    }
}
