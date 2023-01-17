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
    let onOnboardingScreen: () -> Void
    let onMainScreen: (User) -> Void
    
    var body: some View {
        Text("Food Recipes")
            .font(Fonts.custom(.bold, size: Constants.FontSizes.upperLarge))
            .foregroundColor(.red)
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
                    if let user = viewModel.user {
                        onMainScreen(user)
                    } else {
                        onOnboardingScreen()
                    }
                })
            }
    }
}

struct SplashScreen_Previews: PreviewProvider {
    static var previews: some View {
        SplashScreen(onOnboardingScreen: {
        }, onMainScreen: { _ in
        })
    }
}
