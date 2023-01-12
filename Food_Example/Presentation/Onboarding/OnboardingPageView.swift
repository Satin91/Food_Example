//
//  OnboardingPageView.swift
//  Food_Example
//
//  Created by Артур Кулик on 12.01.2023.
//

import SwiftUI

struct OnboardingPageView<Content: View>: View {
    let title: String
    let subTitle: String
    let content: () -> Content
    
    var body: some View {
        VStack(spacing: Constants.Spacing.xs) {
            content()
            Text(title)
                .multilineTextAlignment(.center)
                .font(Fonts.custom(.dmSans, size: Constants.FontSizes.upperLarge))
                .foregroundColor(Color(Colors.dark))
            Text(subTitle)
                .font(Fonts.custom(.regular, size: Constants.FontSizes.small))
                .foregroundColor(Color(Colors.weakDark))
                .multilineTextAlignment(.center)
        }
    }
}

//struct OnboardingPageView_Previews: PreviewProvider {
//    static var previews: some View {
//        OnboardingPageView()
//    }
//}
