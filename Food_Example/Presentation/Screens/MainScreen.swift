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
    @State var isAnimateViews = false
    @State var searchText: String = ""
    let searchViewSize = CGSize(width: 40, height: 40)
    let searchButtonBackground = Colors.border
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
                searchRecipes()
            }
    }
    
    private var content: some View {
        VStack(spacing: .zero) {
            NavigationBarView()
                .addLeftContainer {
                    Text("Most popular recipes")
                        .modifier(LargeNavBarTextModifier())
                        .opacity(isAnimateViews ? 0 : 1)
                        .animation(.easeInOut(duration: 0.1), value: isAnimateViews)
                }
                .addRightContainer {
                    searchView
                }
                .padding(.vertical)
            Divider()
            ScrollView(.vertical) {
                recipesList
            }
        }
    }
    
    private var searchView: some View {
        ZStack {
            RoundedRectangle(cornerRadius: Constants.cornerRadius)
                .stroke(isAnimateViews ? Colors.lightGray : .clear, lineWidth: 1)
                .background(isAnimateViews ? Colors.backgroundWhite : Colors.border)
                .cornerRadius(Constants.cornerRadius)
                .frame(width: isAnimateViews ? .infinity : searchViewSize.width, height: searchViewSize.height)
            HStack(spacing: Constants.Spacing.xxs) {
                Image(Images.icnSearch)
                    .padding(.leading, isAnimateViews ? Constants.Spacing.xxs : .zero)
                    .onTapGesture {
                        animateSearchView()
                    }
                if isAnimateViews {
                    TextField("Search by ingridients", text: $searchText)
                        .frame(width: .infinity)
                        .font(Fonts.makeFont(.regular, size: Constants.FontSizes.medium))
                        .foregroundColor(Colors.dark)
                        .submitLabel(.search)
                        .onSubmit {
                            searchRecipes()
                        }
                }
            }
        }
        .animation(.easeInOut, value: isAnimateViews)
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
    
    private func searchRecipes() {
        container
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
    
    func animateSearchView() {
        isAnimateViews.toggle()
    }
}
