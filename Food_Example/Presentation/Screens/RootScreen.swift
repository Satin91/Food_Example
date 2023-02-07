//
//  RootScreen.swift
//  Food_Example
//
//  Created by Артур Кулик on 07.02.2023.
//

import SwiftUI

struct RootScreen: View {
    // Initialized in AppCoordinator, assigned here
    @State var currentScreen: any TabBarScreen
    // Screens actions
    @State var onShowRecipeScreen: (Recipe) -> Void
    
    var body: some View {
        ZStack {
            currentScreen.content
            TabBar(
                currentElement: $currentScreen,
                tabItems: [
                    SearchRecipesScreen(onShowRecipeScreen: onShowRecipeScreen),
                    FavoriteRecipesScreen()
                ]
            )
        }
    }
}

struct RootScreen_Previews: PreviewProvider {
    static var previews: some View {
        RootScreen(currentScreen: SearchRecipesScreen(onShowRecipeScreen: { _ in }), onShowRecipeScreen: { _ in })
    }
}