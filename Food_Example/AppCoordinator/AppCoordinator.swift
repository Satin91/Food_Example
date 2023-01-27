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
    case recipeScreen(Recipe)
    case signUpScreen
    case signInScreen
    case resetPasswordScreen
}

struct AppCoordinator: View {
    @State var routes: Routes<Screen> = [.root(.recipeScreen(Recipe(id: 0, title: "", image: "")), embedInNavigationView: true)]
    
    var body: some View {
        Router($routes) { screen, _ in
            switch screen {
            case .mainScreen:
                MainScreen(onShowRecipeScreen: pushToRecipeScreen(recipe:))
            case .recipeScreen(let recipe):
                //                RecipeScreen(recipe: recipe, onClose: back)
                RecipeScreen(onClose: back)
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
                    onSignUpScreen: pushToSignUpScreen,
                    onResetPasswordScreen: pushToResetPaswordScreen
                )
            case .resetPasswordScreen:
                ResetPasswordScreen(onClose: back)
            }
        }
        .inject(AppEnvironment.bootstrap().container)
    }
    
    private func pushToSignInScreen() {
        routes.push(.signInScreen)
    }
    
    private func pushToSignUpScreen() {
        routes.push(.signUpScreen)
    }
    
    private func pushToResetPaswordScreen() {
        routes.push(.resetPasswordScreen)
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
    
    private func pushToRecipeScreen(recipe: Recipe) {
        routes.push(.recipeScreen(recipe))
    }
    
    private func back() {
        routes.goBack()
    }
}
