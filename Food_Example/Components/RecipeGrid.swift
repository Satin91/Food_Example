//
//  RecipeGrid.swift
//  Food_Example
//
//  Created by Артур Кулик on 15.01.2023.
//

import CoreML
import SwiftUI
import Vision

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
            imageContainer
            title
        }
        .background(Color.white)
        .cornerRadius(gridCornerRadius)
        .modifier(SmallShadowModifier())
        .frame(alignment: .top)
    }
    
    var title: some View {
        Text(recipe.title)
            .font(Fonts.custom(.bold, size: Constants.FontSizes.small))
            .foregroundColor(Colors.dark)
            .frame(height: 52)
            .padding(Constants.Spacing.xs)
            .lineLimit(2)
    }
    
    var imageContainer: some View {
        ZStack {
            image
            settingsButton
        }
    }
    
    var image: some View {
        AsyncImage(
            url: URL(string: recipe.image),
            content: { image in
                image
                    .resizable()
                    .scaledToFill()
                    .frame(maxHeight: .infinity)
            }, placeholder: {
                Image("mockFood")
                    .resizable()
                    .scaledToFill()
                    .foregroundColor(Colors.lightGray)
                    .frame(maxHeight: .infinity)
            }
        )
        .onAppear {
        }
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
