//
//  NutrientsView.swift
//  Food_Example
//
//  Created by Артур Кулик on 28.01.2023.
//

import SwiftUI

struct NutrientView: View {
    enum NutrientType {
        case carbs(Int)
        case protein(Int)
        case kcal(Int)
        case fats(Int)
    }
    struct Nutrient {
        let imageName: String
        let amount: String
    }
    
    private let imageSize: CGFloat = 36
    let nutrientType: NutrientType
    
    var nutrient: Nutrient {
        switch nutrientType {
        case .carbs(let amount):
            return Nutrient(
                imageName: Images.icnCarbs,
                amount: "\(amount)g carbs "
            )
        case .protein(let amount):
            return Nutrient(
                imageName: Images.icnProtein,
                amount: "\(amount)g protein"
            )
        case .kcal(let amount):
            return Nutrient(
                imageName: Images.icnKcal,
                amount: "\(amount) Kcal"
            )
        case .fats(let amount):
            return Nutrient(
                imageName: Images.icnFats,
                amount: "\(amount)g fats"
            )
        }
    }
    
    var body: some View {
        content
    }
    
    private var content: some View {
        HStack {
            image
            amountText
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    private var image: some View {
        Image(nutrient.imageName)
            .renderingMode(.template)
            .resizable()
            .frame(width: 36, height: 36)
            .foregroundColor(Colors.weakDark)
            .padding(Constants.Spacing.xxxxs)
            .background(Colors.neutralGray)
            .cornerRadius(Constants.smallCornerRadius)
    }
    
    private var amountText: some View {
        Text(nutrient.amount)
            .font(Fonts.makeFont(.regular, size: Constants.FontSizes.extraMedium))
            .foregroundColor(Colors.weakDark)
    }
}

struct NutrientsView_Previews: PreviewProvider {
    static var previews: some View {
        NutrientView(nutrientType: .fats(150))
    }
}
