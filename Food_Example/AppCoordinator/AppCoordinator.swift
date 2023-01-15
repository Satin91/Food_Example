//
//  AppCoordinator.swift
//  Food_Example
//
//  Created by Артур Кулик on 12.01.2023.
//

import FlowStacks
import SwiftUI

enum Screen {
    case splashScreen
    case onboardingScreen
    case mainScreen
    case loginScreen
    case signUpScreen
}

struct AppCoordinator: View {
    @State var routes: Routes<Screen> = [.root(.mainScreen)]
    
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
                OnboardingScreen(onSignUpScreen: {
                    pushToSignUpScreen()
                })
            case .signUpScreen:
                SignUpScreen()
            }
        }
    }
    
    func pushToSignUpScreen() {
        routes.push(.signUpScreen)
    }
    
    func pushOnboardingScreen() {
        routes = [.root(.onboardingScreen, embedInNavigationView: true)]
    }
}
