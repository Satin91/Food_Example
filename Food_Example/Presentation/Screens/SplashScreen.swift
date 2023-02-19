//
//  SplashScreen.swift
//  Food_Example
//
//  Created by Артур Кулик on 12.01.2023.
//

import Combine
import FirebaseAuth
import SwiftUI

struct SplashScreen: View {
    @Environment(\.injected) var container: DIContainer
    let onOnboardingScreen: () -> Void
    let onRootScreen: () -> Void
    let sessionService = SessionServiceImpl()
    @State var cancelBag = Set<AnyCancellable>()
    
    var body: some View {
        VStack {
            LottieView(name: Lottie.loader, loopMode: .loop, speed: 1.5, isStopped: false)
                .frame(width: Constants.loaderLottieSize, height: Constants.loaderLottieSize)
            Text("Food Recipes")
                .font(Fonts.makeFont(.bold, size: Constants.FontSizes.extraLarge))
                .foregroundColor(Colors.red)
                .onAppear {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
                        switch sessionService.state {
                        case .loggedIn(let user):
                            onRootScreen()
                        case .loggedOut:
                            print("Logged out")
                            onOnboardingScreen()
                        }
                    })
                }
        }
    }
}
