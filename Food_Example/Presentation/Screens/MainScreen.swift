//
//  ContentView.swift
//  Food_Example
//
//  Created by Артур Кулик on 11.01.2023.
//

import Combine
import FirebaseAuth
import SwiftUI

struct MainScreen: View {
    @Environment(\.injected) var container: DIContainer
    @State private var searchTextPublisher = CurrentValueSubject<String, Never>("")
    @State private var currentSearchCategory: APIEndpoint = .searchInAll
    @State private var searchParams: [String: String] = [:]
    @State private var cancelBag = Set<AnyCancellable>()
    @State private var recipes: [Recipe] = []
    @State private var isPresentPopup = false
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
                //                searchRecipes()
            }
    }
    
    private var content: some View {
        VStack(spacing: .zero) {
            NavigationBarView()
                .addLeftContainer {
                    navBarLeftContainer
                }
            Divider()
                .zIndex(-1)
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
                    TextField(currentSearchCategory.text, text: $searchTextPublisher.value)
                        .frame(width: .infinity)
                        .font(Fonts.makeFont(.regular, size: Constants.FontSizes.medium))
                        .foregroundColor(Colors.dark)
                        .submitLabel(.search)
                        .onSubmit {
                            searchRecipes()
                        }
                    searchMenu
                }
            }
    }
    
    private var searchMenu: some View {
        Menu {
            Button("Search in all categories") {
                currentSearchCategory = .searchInAll
            }
            Button("Search by igredients") {
                currentSearchCategory = .searchByIngridient
                searchTextPublisher.sink { str in
                    searchParams["ingredients"] = str
                }
                .store(in: &cancelBag)
            }
            Button("Search by nutritients") {
                currentSearchCategory = .searchByNutritients
                searchTextPublisher.sink { str in
                    searchParams["nutritients"] = str
                }
                .store(in: &cancelBag)
            }
        } label: {
            Image(systemName: "slider.vertical.3")
                .resizable()
                .frame(width: 20, height: 20)
                .padding(.trailing, Constants.Spacing.s)
                .foregroundColor(Colors.gray)
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
    
    private func searchRecipes() {
        container
            .interactors
            .recipesInteractor
            .searchRecipesBy(
                params: RecipesRequestParams(urlParams: searchParams),
                path: currentSearchCategory,
                completion: { recipes in
                    self.recipes = recipes
                }
            )
    }
}
