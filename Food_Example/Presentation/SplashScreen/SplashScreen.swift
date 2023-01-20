//
//  SplashScreen.swift
//  Food_Example
//
//  Created by Артур Кулик on 12.01.2023.
//

import FirebaseAuth
import SwiftUI

struct SplashScreen: View {
    @ObservedObject var viewModel = SplashScreenViewModel()
    @Environment(\.injected) var container: DIContainer
    let onOnboardingScreen: () -> Void
    let onMainScreen: () -> Void
    
    var body: some View {
        Text("Food Recipes")
            .font(Fonts.custom(.bold, size: Constants.FontSizes.upperLarge))
            .foregroundColor(.red)
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
                    switch container.appState.sessionService.state {
                    case .loggedIn:
                        // onMainScreen()
                        onOnboardingScreen()
                    case .loggedOut:
                        onOnboardingScreen()
                    }
                })
            }
    }
}
