//
//  ContentView.swift
//  Food_Example
//
//  Created by Артур Кулик on 11.01.2023.
//

import FirebaseAuth
import SwiftUI

struct MainScreen: View {
    @Environment(\.injected) var container: DIContainer
    @State var recipes: [Recipe] = []
    @State var searchText: String = ""
    let searchViewHeight: CGFloat = 56
    let searchButtonBackground = Colors.neutralGray
    let onShowRecipeScreen: (_ id: Recipe) -> Void
    
    let columns = [
        GridItem(.flexible(), spacing: 0),
        GridItem(.flexible(), spacing: 0)
    ]
    @State var gridWidth: CGFloat = 0
    
    var body: some View {
        content
            .toolbar(.hidden)
            .onAppear {
                Task {
                    await searchRecipes()
                }
            }
    }
    
    private var content: some View {
        VStack(spacing: .zero) {
            NavigationBarView()
                .addLeftContainer {
                    navBarLeftContainer
                }
            Divider()
            ScrollView(.vertical) {
                recipesList
            }
        }
    }
    
    private var navBarLeftContainer: some View {
        VStack(alignment: .leading, spacing: .zero) {
            Text("Hello!")
                .font(Fonts.makeFont(.bold, size: 48))
            Text("What do you want to cook?")
                .font(Fonts.makeFont(.regular, size: Constants.FontSizes.extraMedium))
                .foregroundColor(.gray)
            searchView
                .padding(.vertical)
        }
    }
    
    private var searchView: some View {
        RoundedRectangle(cornerRadius: Constants.cornerRadius)
            .foregroundColor(.white)
            .background(Colors.backgroundWhite)
            .cornerRadius(Constants.cornerRadius)
            .frame(width: .infinity, height: searchViewHeight)
            .modifier(LightShadowModifier())
            .overlay {
                HStack(spacing: Constants.Spacing.xs) {
                    Image(Images.icnSearch)
                        .renderingMode(.template)
                        .foregroundColor(Colors.gray)
                        .padding(.leading, Constants.Spacing.s)
                    TextField("Search by ingridients", text: $searchText)
                        .frame(width: .infinity)
                        .font(Fonts.makeFont(.regular, size: Constants.FontSizes.medium))
                        .foregroundColor(Colors.dark)
                        .submitLabel(.search)
                        .onSubmit {
                            Task {
                                await searchRecipes()
                            }
                        }
                }
            }
    }
    
    private var recipesList: some View {
        LazyVGrid(columns: columns, spacing: 0) {
            ForEach(recipes) { recipe in
                RecipeGrid(
                    recipe: recipe,
                    action: {
                        onShowRecipeScreen(recipe)
                    }, settingsAction: {
                        print("Settings Action")
                    }
                )
                .padding(Constants.Spacing.xs)
            }
        }
    }
    
    private func searchRecipes() async {
        await container
            .interactors
            .recipesInteractor
            .searchRecipesBy(
                params: RecipesRequestParams(
                    query: searchText,
                    includeIngridients: "",
                    number: 15,
                    maxFat: 600
                ), completion: { recipes in
                    self.recipes = recipes
                }
            )
    }
}

struct MainScreen_Previews: PreviewProvider {
    static var previews: some View {
        MainScreen { _ in
        }
    }
}
