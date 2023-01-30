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
        HStack {
            LoadableImage(urlString: ingredient.imageURL)
                .scaledToFit()
                .frame(width: 34, height: 34)
            Spacer()
            Text(ingredient.name)
                .font(Fonts.makeFont(.regular, size: Constants.FontSizes.medium))
                .foregroundColor(Colors.dark)
        }
    }
}
