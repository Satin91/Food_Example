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
    @StateObject var imageLoader = ImageLoader()
    let recipe: Recipe
    let gridCornerRadius: CGFloat = 12
    let settingsButtonSize: CGFloat = 24
    let imageHeight: CGFloat = 110
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
        .frame(alignment: .top)
        .modifier(LightShadowModifier(color: Colors.neutralGray))
        .onAppear {
            imageLoader.downloadImage(urlString: recipe.image)
        }
    }
    
    var title: some View {
        Text(recipe.title)
            .font(Fonts.makeFont(.semiBold, size: Constants.FontSizes.small))
            .foregroundColor(Colors.weakDark)
            .frame(height: 40)
            .padding(.horizontal, Constants.Spacing.xs)
            .padding(.bottom, Constants.Spacing.xs)
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
            .frame(height: imageHeight)
            .padding(.bottom, Constants.Spacing.xs)
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
        .padding(Constants.Spacing.m)
    }
}
