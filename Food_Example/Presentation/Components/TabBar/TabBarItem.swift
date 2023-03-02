//
//  TabBarItem.swift
//  iosApp
//
//  Created by Артур Кулик on 04.10.2022.
//  Copyright © 2022 orgName. All rights reserved.
//

import SwiftUI

struct TabBarItem: View {
    let itemImage: String
    let itemIndex: Int
    let selectedColor: Color
    let placeHolderColor = Colors.silver
    let iconSize: CGFloat = 30
    
    var isSelected: Bool
    
    var body: some View {
        HStack(spacing: .zero) {
            Image(itemImage)
                .resizable()
                .renderingMode(.template)
                .foregroundColor(
                    isSelected ? selectedColor : placeHolderColor
                )
                .modifier(LightShadowModifier(color: isSelected ? selectedColor : .clear))
                .frame(width: iconSize, height: iconSize, alignment: .top)
        }
        .padding(Constants.Spacing.xxs)
        .padding(.horizontal, Constants.Spacing.s)
        .background(isSelected ? Colors.neutralGray.opacity(0.1) : .clear)
        .cornerRadius(12)
    }
}

struct TabBarItem_Previews: PreviewProvider {
    static var previews: some View {
        TabBarItem(
            itemImage: Images.icnFilter,
            itemIndex: 0,
            selectedColor: Colors.red,
            isSelected: true
        )
    }
}
