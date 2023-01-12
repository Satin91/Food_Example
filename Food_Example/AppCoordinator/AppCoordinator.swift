//
//  AppCoordinator.swift
//  Food_Example
//
//  Created by Артур Кулик on 12.01.2023.
//

import SwiftUI
import FlowStacks

enum Screen {
    case mainScreen
    case splashScreen
    case loginScreen
}

struct AppCoordinator: View {
    @State var routes: Routes<Screen> = [.root(.splashScreen)]
    
    var body: some View {
        Router($routes) { screen, _ in
            switch screen {
            case .mainScreen:
                MainScreen()
            case .splashScreen:
                SplashScreen()
            case .loginScreen:
                EmptyView()
            }
        }
    }
}
