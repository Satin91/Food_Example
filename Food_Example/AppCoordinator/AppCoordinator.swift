//
//  AppCoordinator.swift
//  Food_Example
//
//  Created by Артур Кулик on 12.01.2023.
//

import SwiftUI
import FlowStacks

enum Screen {
    case splashScreen
    case onboardingScreen
    case mainScreen
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
                SplashScreen(onOnboardingScreen: pushOnboardingScreen)
            case .loginScreen:
                EmptyView()
            case .onboardingScreen:
                OnboardingScreen()
            }
        }
    }
    
    func pushOnboardingScreen() {
        routes = [.root(.onboardingScreen, embedInNavigationView: true)]
    }
}
