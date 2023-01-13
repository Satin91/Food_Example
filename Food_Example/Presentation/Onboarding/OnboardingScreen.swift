//
//  OnboardingScreen.swift
//  Food_Example
//
//  Created by Артур Кулик on 12.01.2023.
//

import SwiftUI

struct OnboardingScreen: View {
    @State var currentStep: Int = 0
    
    var body: some View {
        ZStack {
            tabView
            bottomView
        }
    }
    
    private var tabView: some View {
        TabView(selection: $currentStep) {
            OnboardingPageView(
                image: Images.icnBurger,
                title: "Burgets and other fastfood",
                subTitle: "Discover our best burger, kebab, hot dog recipes."
            )
            .tag(0)
            OnboardingPageView(
                image: Images.icnCoffee,
                title: "Coffee and shake drink",
                subTitle: "Brew delicious coffee or tea, recipes for every taste!"
            )
            .tag(1)
            OnboardingPageView(
                image: Images.icnMuffin,
                title: "Are you a sweet tooth?",
                subTitle: "Lots of recipes for you, just don't overeat!"
            )
            .tag(2)
            OnboardingPageView(
                image: Images.icnPizza,
                title: "Well, how about without pizza!",
                subTitle: "Huge selection of pizza, salad and long cooking recipes."
            )
            .tag(3)
            OnboardingPageView(
                image: Images.icnFrenchFriesRed,
                title: "Let's cooking!",
                subTitle: ""
            )
            .tag(4)
            
        }
        .tabViewStyle(.page)
        .animation(.easeInOut, value: currentStep)
        .transition(.slide)
    }
    
    var bottomView: some View {
        VStack(spacing: Constants.Spacing.zero) {
            Spacer()
            if currentStep == 4 {
                CapsuleButton(
                    title: "Get started now",
                    action: {
                        print("Button tapped")
                    }
                )
                .frame(width: Constants.ButtonWidth.medium)
            } else {
                 NavigationButton(currentStep: $currentStep)
            }
        }
    }
}

struct OnboardingScreen_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingScreen()
    }
}
