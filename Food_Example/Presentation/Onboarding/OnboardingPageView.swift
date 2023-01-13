//
//  OnboardingPageView.swift
//  Food_Example
//
//  Created by Артур Кулик on 12.01.2023.
//

import SwiftUI

struct OnboardingPageView: View {
    let image: String
    let title: String
    let subTitle: String
    let imageSize: CGFloat = 240
    
    var body: some View {
        VStack(spacing: Constants.Spacing.xs) {
            foodImage(image)
            Text(title)
                .multilineTextAlignment(.center)
                .font(Fonts.custom(.dmSans, size: Constants.FontSizes.upperLarge))
                .foregroundColor(Color(Colors.dark))
            Text(subTitle)
                .font(Fonts.custom(.regular, size: Constants.FontSizes.small))
                .foregroundColor(Color(Colors.weakDark))
                .multilineTextAlignment(.center)
        }
        .padding(.horizontal, Constants.Spacing.m)
    }
    private func foodImage(_ image: String) -> some View {
        Image(image)
            .resizable()
            .frame(width: imageSize, height: imageSize)
            .modifier(LargeShadowModifier())
    }
}

//struct OnboardingPageView_Previews: PreviewProvider {
//    static var previews: some View {
//        OnboardingPageView()
//    }
//}
