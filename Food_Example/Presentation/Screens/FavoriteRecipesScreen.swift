//
//  FavoriteRecipesScreen.swift
//  Food_Example
//
//  Created by Артур Кулик on 07.02.2023.
//

import RealmSwift
import SwiftUI

struct FavoriteRecipesScreen: View, TabBarActor {
    var tabImage: String = Images.icnHomeFilled
    var tabSelectedColor: Color = Colors.dark
    @Environment(\.injected) var container: DIContainer
    var onShowRecipeScreen: (Recipe) -> Void
    
    var body: some View {
        content
            .toolbar(.hidden)
    }
    
    private var content: some View {
        VStack {
            navigationBar
            favoriteRecipesList
        }
    }
    
    private var navigationBar: some View {
        NavigationBarView()
            .addLeftContainer {
                Text("Favorites Recipes")
                    .modifier(LargeNavBarTextModifier())
            }
    }
    
    private var favoriteRecipesList: some View {
        List {
            ForEach(container.appState.value.userRecipes) { object in
                FavoriteRecipeRow(recipeRealm: object)
                    .listRowSeparator(.hidden)
                    .listRowInsets(EdgeInsets(.zero))
                    .onTapGesture {
                        onShowRecipeScreen(object)
                    }
            }
            .onDelete { indexSet in
                container.interactors.recipesInteractor.removeFavorite(index: indexSet.first!)
            }
        }
        .listStyle(.plain)
    }
}

struct FavoriteRecipeRow: View {
    let recipeRealm: Recipe
    let contentSize: CGFloat = 64
    
    var body: some View {
        content
    }
    
    var content: some View {
        VStack(spacing: .zero) {
            HStack(spacing: Constants.Spacing.xs) {
                image
                title
                Spacer(minLength: .zero)
                chevroneImage
            }
            .padding(.vertical, Constants.Spacing.s)
            separator
        }
        .padding(.horizontal, Constants.Spacing.s)
    }
    
    var chevroneImage: some View {
        Image(Images.icnChevronRight)
            .foregroundColor(Colors.silver)
    }
    
    var title: some View {
        Text(recipeRealm.title)
            .font(Fonts.makeFont(.medium, size: Constants.FontSizes.extraMedium))
            .foregroundColor(Colors.dark)
            .multilineTextAlignment(.leading)
            .lineLimit(2)
            .frame(height: contentSize)
    }
    
    var image: some View {
        LoadableImage(urlString: recipeRealm.image)
            .frame(width: contentSize, height: contentSize)
            .cornerRadius(8)
    }
    
    var separator: some View {
        Rectangle()
            .frame(maxWidth: .infinity)
            .frame(height: 1)
            .foregroundColor(Colors.neutralGray)
    }
}

// struct FavoritsRecipesScreen_Previews: PreviewProvider {
//     static var previews: some View {
//         FavoriteRecipesScreen()
//     }
// }
