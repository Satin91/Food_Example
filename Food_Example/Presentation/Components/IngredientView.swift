//
//  IngredientView.swift
//  Food_Example
//
//  Created by Артур Кулик on 30.01.2023.
//

import SwiftUI

struct IngredientView: View {
    let ingredient: Ingredient
    var body: some View {
        content
    }
    
    var content: some View {
        VStack {
            HStack {
                LoadableImage(urlString: ingredient.imageURL)
                    .scaledToFit()
                    .frame(width: 46, height: 46)
                Text(ingredient.name)
                    .font(Fonts.makeFont(.medium, size: Constants.FontSizes.medium))
                    .foregroundColor(Colors.dark)
                Spacer()
                Text(String(ingredient.value))
                    .font(Fonts.makeFont(.semiBold, size: Constants.FontSizes.medium))
                    .foregroundColor(Colors.dark)
            }
            .padding()
            .background(Color.white)
            .cornerRadius(Constants.cornerRadius)
            .modifier(LightShadowModifier())
        }
    }
}
