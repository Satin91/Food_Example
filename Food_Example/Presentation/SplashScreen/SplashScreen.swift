//
//  SplashScreen.swift
//  Food_Example
//
//  Created by Артур Кулик on 12.01.2023.
//

import SwiftUI

struct SplashScreen: View {
    let onOnboardingScreen: () -> Void
    
    var body: some View {
        Text("Food Recipes")
            .font(Fonts.custom(.bold, size: Constants.FontSizes.upperLarge))
            .foregroundColor(.red)
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
                    self.onOnboardingScreen()
                })
            }
    }
}

struct SplashScreen_Previews: PreviewProvider {
    static var previews: some View {
        SplashScreen(onOnboardingScreen: {
        })
    }
}
