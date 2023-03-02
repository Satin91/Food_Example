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
    var tabSelectedColor: Color = Colors.red
    
    @Environment(\.injected) var container: DIContainer
    @State private var recipes = RealmSwift.List<Recipe>()
    @State var isShowEmptyView = false
    var onShowRecipeScreen: (Recipe) -> Void
    
    var body: some View {
        content
            .onReceive(container.appState.eraseToAnyPublisher(), perform: { isShowEmptyView = $0.userRecipes.isEmpty })
            .toolbar(.hidden)
    }
    
    private var content: some View {
        VStack {
            navigationBar
            favoriteRecipesList
                .overlay {
                    emptyFavoriteRecipesView
                        .opacity(isShowEmptyView ? 1 : 0)
                        .animation(.easeIn(duration: 0.3), value: isShowEmptyView)
                }
            Spacer()
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
    
    private var emptyFavoriteRecipesView: some View {
        VStack(spacing: Constants.Spacing.s) {
            Text("No favorite recipes yet")
                .font(Fonts.makeFont(.light, size: Constants.FontSizes.extraLarge))
                .foregroundColor(Colors.silver)
                .multilineTextAlignment(.center)
            Text("Find a recipe, mark it as a favorite.")
                .font(Fonts.makeFont(.light, size: Constants.FontSizes.extraMedium))
                .foregroundColor(Colors.weakBlue)
        }
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
