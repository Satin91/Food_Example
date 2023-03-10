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
                .font(Fonts.makeFont(.dmSans, size: Constants.FontSizes.extraLarge))
                .foregroundColor(Colors.dark)
            Text(subTitle)
                .font(Fonts.makeFont(.regular, size: Constants.FontSizes.small))
                .foregroundColor(Colors.weakDark)
                .multilineTextAlignment(.center)
                .frame(minHeight: 60)
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
