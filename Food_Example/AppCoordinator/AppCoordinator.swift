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
    case rootScreen
    case splashScreen
    case onboardingScreen
    case mainScreen
    case favoriteRecipeScreen
    case recipeScreen(Recipe)
    case instructionsScreen(URL)
    case signUpScreen
    case signInScreen
    case resetPasswordScreen
}

struct AppCoordinator: View {
    @State var routes: Routes<Screen> = [.root(.splashScreen, embedInNavigationView: true)]
    
    var body: some View {
        Router($routes) { screen, _ in
            switch screen {
            case .rootScreen:
                RootScreen(
                    currentScreen: SearchRecipesScreen(onShowRecipeScreen: pushToRecipeScreen(recipe:)),
                    onShowRecipeScreen: pushToRecipeScreen(recipe:),
                    backToSignInScreen: {
                        backToSignInScreen()
                    }
                )
            case .mainScreen:
                SearchRecipesScreen(onShowRecipeScreen: pushToRecipeScreen(recipe:))
            case .favoriteRecipeScreen:
                FavoriteRecipesScreen()
            case .recipeScreen(let recipe):
                RecipeScreen(
                    recipe: recipe,
                    onClose: back,
                    onShowInstructions: presentInstructions(url:)
                )
            case .splashScreen:
                SplashScreen(
                    onOnboardingScreen: rootOnboardingScreen,
                    onRootScreen: rootRootScreen
                )
            case .onboardingScreen:
                OnboardingScreen(onSignUpScreen: pushToSignInScreen)
            case .signUpScreen:
                SignUpScreen(
                    onMainScreen: pushToRootScreen,
                    onClose: back
                )
            case .signInScreen:
                SignInScreen(
                    onRootScreen: pushToRootScreen,
                    onSignUpScreen: pushToSignUpScreen,
                    onResetPasswordScreen: pushToResetPaswordScreen
                )
            case .resetPasswordScreen:
                ResetPasswordScreen(onClose: back)
            case .instructionsScreen(let url):
                InstructionsScreen(url: url)
            }
        }
        .inject(AppEnvironment.bootstrap().container)
    }
    
    // MARK: Push
    private func pushToSignInScreen() {
        routes.push(.signInScreen)
    }
    
    private func pushToSignUpScreen() {
        routes.push(.signUpScreen)
    }
    
    private func pushToResetPaswordScreen() {
        routes.push(.resetPasswordScreen)
    }
    
    private func pushToMainScreen() {
        routes.push(.mainScreen)
    }
    
    private func pushToRootScreen() {
        routes.push(.rootScreen)
    }
    
    // MARK: Root
    private func rootOnboardingScreen() {
        routes = [.root(.onboardingScreen, embedInNavigationView: true)]
    }
    
    private func rootRootScreen() {
        routes = [.root(.rootScreen, embedInNavigationView: true)]
    }
    
    // MARK: Present modaly
    private func presentInstructions(url: URL) {
        routes.presentSheet(.instructionsScreen(url))
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
    
    private func backToSignInScreen() {
        routes = [.cover(.signInScreen, embedInNavigationView: true)]
    }
}
