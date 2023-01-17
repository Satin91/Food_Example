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
    case mainScreen(User?)
    case signUpScreen
    case signInScreen
}

struct AppCoordinator: View {
    @State var routes: Routes<Screen> = [.root(.signInScreen)]
    
    var body: some View {
        Router($routes) { screen, _ in
            switch screen {
            case .mainScreen:
                MainScreen(user: nil)
            case .splashScreen:
                SplashScreen(
                    onOnboardingScreen: pushOnboardingScreen,
                    onMainScreen: onMainScreen(_:)
                )
            case .onboardingScreen:
                OnboardingScreen(onSignUpScreen: {
                    pushToSignUpScreen()
                })
            case .signUpScreen:
                SignUpScreen()
            case .signInScreen:
                SignInScreen(
                    onMainScreen: {
                        onMainScreen(nil)
                    },
                    onSignUpScreen: {
                        pushToSignUpScreen()
                    }
                )
            }
        }
    }
    
    func pushToSignUpScreen() {
        routes.push(.signUpScreen)
    }
    
    func pushOnboardingScreen() {
        routes = [.root(.onboardingScreen, embedInNavigationView: true)]
    }
    
    private func pushToMainScreen() {
        routes.push(.mainScreen(nil))
    }
    
    private func onMainScreen(_ user: User?) {
        routes = [.root(.mainScreen(user), embedInNavigationView: true)]
    }
}
