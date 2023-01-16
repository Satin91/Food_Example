//
//  RecipeGrid.swift
//  Food_Example
//
//  Created by Артур Кулик on 15.01.2023.
//

import SwiftUI

struct RecipeGrid: View {
    let recipe: Recipe
    let imageHeight: CGFloat = 100
    let gridCornerRadius: CGFloat = 12
    let settingsButtonSize: CGFloat = 24
    let action: () -> Void
    let settingsAction: () -> Void
    
    var body: some View {
        content
            .onTapGesture {
                action()
            }
    }
    
    var content: some View {
        VStack(alignment: .leading, spacing: Constants.Spacing.zero) {
            ZStack {
                image
                settingsButton
            }
            Text(recipe.title)
                .font(Fonts.custom(.bold, size: Constants.FontSizes.small))
                .foregroundColor(Colors.dark)
                .padding(Constants.Spacing.s)
                .lineLimit(2)
        }
        .background(Color.white)
        .cornerRadius(gridCornerRadius)
        .modifier(SmallShadowModifier())
        .frame(alignment: .top)
    }
    
    var image: some View {
        Image("mockFood")
            .resizable()
            .scaledToFill()
            .foregroundColor(Colors.lightGray)
            .frame(maxHeight: .infinity)
    }
    
    var settingsButton: some View {
        VStack(spacing: Constants.Spacing.zero) {
            HStack(spacing: Constants.Spacing.zero) {
                Spacer()
                Image(Images.icnSettingsVertical)
                    .renderingMode(.template)
                    .foregroundColor(Colors.dark)
                    .background(
                        Capsule()
                            .foregroundColor(.white.opacity(0.6))
                            .frame(
                                width: settingsButtonSize,
                                height: settingsButtonSize
                            )
                    )
                    .onTapGesture {
                        settingsAction()
                    }
            }
            Spacer()
        }
        .padding(Constants.Spacing.s)
    }
}
