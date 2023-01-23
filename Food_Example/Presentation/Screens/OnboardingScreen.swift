//
//  OnboardingScreen.swift
//  Food_Example
//
//  Created by Артур Кулик on 12.01.2023.
//

import SwiftUI

struct OnboardingScreen: View {
    @State var currentStep: Int = 0
    let onSignUpScreen: () -> Void
    
    var body: some View {
        content
    }
    
    private var content: some View {
        ZStack {
            tabView
            bottomView
        }
    }
    
    let pages: [OnboardingPageView] = [
        OnboardingPageView(
            image: Images.icnBurger,
            title: "Burgets and other fastfood",
            subTitle: "Discover our best burger, kebab, hot dog recipes."
        ),
        OnboardingPageView(
            image: Images.icnCoffee,
            title: "Coffee and shake drink",
            subTitle: "Brew delicious coffee or tea, recipes for every taste!"
        ),
        OnboardingPageView(
            image: Images.icnMuffin,
            title: "Are you a sweet tooth?",
            subTitle: "Lots of recipes for you, just don't overeat!"
        ),
        OnboardingPageView(
            image: Images.icnPizza,
            title: "Well, how about without pizza!",
            subTitle: "Huge selection of pizza, salad and long cooking recipes."
        ),
        OnboardingPageView(
            image: Images.icnSandwich,
            title: "Let's cooking!",
            subTitle: ""
        )
    ]
    
    private var tabView: some View {
        TabView(selection: $currentStep) {
            ForEach(0..<pages.count, id: \.self) { index in
                GeometryReader { proxy in
                    pages[index]
                        .tag(index)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .rotation3DEffect(
                            Angle(degrees: proxy.frame(in: .global).minX) / -10,
                            axis: (x: 0, y: 1, z: 0)
                        )
                }
            }
        }
        .tabViewStyle(.page(indexDisplayMode: .never))
        .animation(.easeInOut, value: currentStep)
        .transition(.slide)
    }
    
    var bottomView: some View {
        VStack(spacing: .zero) {
            Spacer()
            if currentStep == 4 {
                CapsuleButton(
                    title: "Get started now",
                    action: {
                        onSignUpScreen()
                    }
                )
                .frame(width: Constants.ButtonWidth.medium)
                .modifier(LargeShadowModifier())
            } else {
                OnboardingNavigationButton(currentStep: $currentStep)
            }
        }
        .padding(.bottom, Constants.Spacing.m)
    }
}

struct OnboardingScreen_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingScreen(onSignUpScreen: {})
    }
}
