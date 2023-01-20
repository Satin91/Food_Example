//
//  AppCoordinator.swift
//  Food_Example
//
//  Created by Артур Кулик on 12.01.2023.
//

import FirebaseAuth
import FlowStacks
import SwiftUI

enum Screen {
    case splashScreen
    case onboardingScreen
    case mainScreen
    case signUpScreen
    case signInScreen
}

struct AppCoordinator: View {
    @State var routes: Routes<Screen> = [.root(.splashScreen, embedInNavigationView: true)]
    
    var body: some View {
        Router($routes) { screen, _ in
            switch screen {
            case .mainScreen:
                MainScreen()
            case .splashScreen:
                SplashScreen(
                    onOnboardingScreen: pushOnboardingScreen,
                    onMainScreen: onMainScreen
                )
            case .onboardingScreen:
                OnboardingScreen(onSignUpScreen: pushToSignInScreen)
            case .signUpScreen:
                SignUpScreen(
                    onMainScreen: pushToMainScreen,
                    onClose: back
                )
            case .signInScreen:
                SignInScreen(
                    onMainScreen: pushToMainScreen,
                    onSignUpScreen: pushToSignUpScreen
                )
                .inject(AppEnvironment.bootstrap().container)
            }
        }
    }
    
    private func pushToSignInScreen() {
        routes.push(.signInScreen)
    }
    
    private func pushToSignUpScreen() {
        routes.push(.signUpScreen)
    }
    
    private func pushOnboardingScreen() {
        routes = [.root(.onboardingScreen, embedInNavigationView: true)]
    }
    
    private func pushToMainScreen() {
        routes.push(.mainScreen)
    }
    
    private func onMainScreen() {
        routes = [.root(.mainScreen, embedInNavigationView: true)]
    }
    
    private func back() {
        routes.goBack()
    }
}
