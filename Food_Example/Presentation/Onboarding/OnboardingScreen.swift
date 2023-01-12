//
//  OnboardingScreen.swift
//  Food_Example
//
//  Created by Артур Кулик on 12.01.2023.
//

import SwiftUI

struct OnboardingScreen: View {
    let imageSize: CGFloat = 240
    var body: some View {
        tabView
    }
    
    private var tabView: some View {
        TabView {
            OnboardingPageView(title: "Burgets and other fastfood", subTitle: "Discover our best burger, kebab, hot dog recipes.") {
                foodImage(Images.icnBurger)
            }
            OnboardingPageView(title: "Coffee and shake drink", subTitle: "Brew delicious coffee or tea, recipes for every taste!") {
                foodImage(Images.icnCoffee)
            }
            OnboardingPageView(title: "Are you a sweet tooth?", subTitle: "Lots of recipes for you, just don't overeat!") {
                foodImage(Images.icnMuffin)
            }
            OnboardingPageView(title: "Well, how about without pizza!", subTitle: "Huge selection of pizza, salad and long cooking recipes.") {
                foodImage(Images.icnPizza)
            }
        }
        .tabViewStyle(.page)
        .padding(.horizontal, Constants.Spacing.m)
    }
    
    private func foodImage(_ image: String) -> some View {
        Image(image)
            .resizable()
            .frame(width: imageSize, height: imageSize)
            .shadow(color: .black.opacity(0.5), radius: Constants.Spacing.s, y: Constants.Spacing.xl)
    }
}

struct OnboardingScreen_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingScreen()
    }
}
