//
//  TabBar.swift
//  iosApp
//
//  Created by Артур Кулик on 04.10.2022.
//  Copyright © 2022 orgName. All rights reserved.
//

import SwiftUI

struct TabBar: View {
    @Binding var currentElement: any TabBarScreen
    @State var currentIndex: Int = 0
    var tabItems: [any TabBarScreen]
    let topPadding: CGFloat = 14
    let tabBarHeight: CGFloat = 100
    
    var body: some View {
        VStack {
            Spacer()
            ZStack {
                tabItemsContainer
            }
        }
        .ignoresSafeArea()
    }
    
    private var tabItemsContainer: some View {
        VStack {
            HStack(alignment: .top, spacing: 0) {
                ForEach(tabItems.indices, id: \.self) { index in
                    TabBarItem(
                        itemImage: tabItems[index].tabImage,
                        itemIndex: index,
                        selectedColor: tabItems[index].tabSelectedColor,
                        isSelected: currentIndex == index
                    )
                    .onTapGesture {
                        currentIndex = index
                    }
                    .frame(height: tabBarHeight - topPadding * 2, alignment: .top)
                    .frame(maxWidth: .infinity)
                    .onChange(of: currentIndex) { index in
                        currentElement = tabItems[index]
                    }
                }
            }
        }
    }
}
