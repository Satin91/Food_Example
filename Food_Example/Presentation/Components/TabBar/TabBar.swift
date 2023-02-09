//
//  TabBar.swift
//  iosApp
//
//  Created by Артур Кулик on 04.10.2022.
//  Copyright © 2022 orgName. All rights reserved.
//

import SwiftUI

struct TabBar: View {
    @Binding var currentScreen: any TabBarScreen
    @State var currentIndex: Int = 0
    var tabItems: [any TabBarScreen]
    
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
                    .animation(.easeInOut(duration: 0.15), value: currentIndex)
                    .onTapGesture {
                        currentIndex = index
                    }
                    .frame(maxWidth: .infinity)
                    .onChange(of: currentIndex) { index in
                        currentScreen = tabItems[index]
                    }
                }
            }
            .padding(.bottom, Constants.Spacing.l)
            .padding(.top, Constants.Spacing.s)
        }
        .background(Color.white)
        .modifier(LargeShadowModifier())
    }
}
