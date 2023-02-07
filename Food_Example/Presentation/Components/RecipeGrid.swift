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
    @StateObject var imageLoader = ImageLoader()
    let action: () -> Void
    let settingsAction: () -> Void
    
    var body: some View {
        content
            .onTapGesture {
                action()
            }
    }
    
    var content: some View {
        VStack(alignment: .leading, spacing: .zero) {
            imageContainer
            title
        }
        .background(Color.white)
        .cornerRadius(gridCornerRadius)
        .modifier(LightShadowModifier())
        .frame(alignment: .top)
        .padding(Constants.Spacing.s)
        .onAppear {
            imageLoader.loadImage(urlString: recipe.image)
        }
    }
    
    var title: some View {
        Text(recipe.title)
            .font(Fonts.makeFont(.bold, size: Constants.FontSizes.small))
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
        Image(uiImage: imageLoader.image)
            .resizable()
            .scaledToFill()
            .frame(maxHeight: .infinity)
    }
    
    var settingsButton: some View {
        VStack(spacing: .zero) {
            HStack(spacing: .zero) {
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
