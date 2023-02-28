//
//  RootScreen.swift
//  Food_Example
//
//  Created by Артур Кулик on 07.02.2023.
//

import RealmSwift
import SwiftUI

struct RootScreen: View {
    // Initialized in AppCoordinator, assigned here
    @State var currentScreen: any TabBarActor
    // Screens actions
    @State var onShowRecipeScreen: (Recipe) -> Void
    @State var onAccountSettingsScreen: () -> Void
    @State var backToSignInScreen: () -> Void
    @Environment(\.injected) var container: DIContainer
    
    var body: some View {
        ZStack {
            currentScreen.content
            TabBar(
                currentScreen: $currentScreen,
                tabItems: [
                    SearchRecipesScreen(onShowRecipeScreen: onShowRecipeScreen),
                    FavoriteRecipesScreen(onShowRecipeScreen: onShowRecipeScreen),
                    AccountScreen(
                        onAccoundSettingsScreen: onAccountSettingsScreen,
                        backToSignInScreen: backToSignInScreen
                    )
                ]
            )
        }
        .onAppear {
            container.interactors.recipesInteractor.compareRemoteAndLocalRecipes()
        }
    }
}

struct RootScreen_Previews: PreviewProvider {
    static var previews: some View {
        RootScreen(currentScreen: SearchRecipesScreen(onShowRecipeScreen: { _ in }), onShowRecipeScreen: { _ in }, onAccountSettingsScreen: {}, backToSignInScreen: {})
    }
}
