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
    @State var routes: Routes<Screen> = [.root(.splashScreen, embedInNavigationView: true)]
    
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
                    pushToSignInScreen()
                })
            case .signUpScreen:
                SignUpScreen(
                    onMainScreen: { pushToMainScreen() },
                    onClose: { backToSignInScreen() }
                )
            case .signInScreen:
                SignInScreen(
                    onMainScreen: {
                        pushToMainScreen()
                    },
                    onSignUpScreen: {
                        pushToSignUpScreen()
                    }
                )
            }
        }
    }
    
    func pushToSignInScreen() {
        routes.push(.signInScreen)
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
    
    private func backToSignInScreen() {
        routes.goBack()
    }
    
    private func onMainScreen(_ user: User?) {
        routes = [.root(.mainScreen(user), embedInNavigationView: true)]
    }
}
