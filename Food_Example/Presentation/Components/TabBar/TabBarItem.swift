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
    var isSelected: Bool
    let iconSize: CGFloat = 30
    var body: some View {
        Image(itemImage)
            .resizable()
            .renderingMode(.template)
            .foregroundColor(
                isSelected ? selectedColor : placeHolderColor
            )
            .frame(width: iconSize, height: iconSize, alignment: .top)
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
