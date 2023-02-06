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
    // Nutritient text
    @State private var fatTextPublisher = CurrentValueSubject<String, Never>("")
    @State private var proteinTextPublisher = CurrentValueSubject<String, Never>("")
    @State private var caloriesTextPublisher = CurrentValueSubject<String, Never>("")
    @State private var carbsTextPublisher = CurrentValueSubject<String, Never>("")
    @State private var currentSearchCategory: APIEndpoint = .searchInAll
    @State private var searchParams: [String: String] = [:]
    @State private var cancelBag = Set<AnyCancellable>()
    @State private var navigationBarHeight: CGFloat = 0
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
            HStack(spacing: .zero) {
                Text("Hello!")
                    .font(Fonts.makeFont(.bold, size: 48))
                Spacer()
                searchMenu
            }
            Text("What do you want to cook?")
                .font(Fonts.makeFont(.regular, size: Constants.FontSizes.extraMedium))
                .foregroundColor(.gray)
            searchView
                .padding(.vertical)
        }
    }
    
    @ViewBuilder private var searchView: some View {
        if currentSearchCategory == .searchByNutritients {
            nutritientsSearchViewContainer
        } else {
            roundedBackground(content: defaultSearchView)
        }
    }
    
    private var defaultSearchView: some View {
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
        }
    }
    
    private var searchMenu: some View {
        Menu {
            Button("Search in all categories") {
                currentSearchCategory = .searchInAll
                searchTextPublisher.sink { str in
                    searchParams["query"] = str
                }
                .store(in: &cancelBag)
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
                caloriesTextPublisher.sink { str in searchParams["minCalories"] = str }
                    .store(in: &cancelBag)
                proteinTextPublisher.sink { str in searchParams["minProtein"] = str }
                    .store(in: &cancelBag)
                fatTextPublisher.sink { str in searchParams["minFat"] = str }
                    .store(in: &cancelBag)
                carbsTextPublisher.sink { str in searchParams["minCarbs"] = str }
                    .store(in: &cancelBag)
            }
        } label: {
            Image(systemName: "slider.vertical.3")
                .resizable()
                .frame(width: 20, height: 20)
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
    
    private var nutritientsSearchViewContainer: some View {
        VStack(spacing: Constants.Spacing.s) {
            Group {
                HStack {
                    roundedBackground(content: nutritientsSearchView(text: $fatTextPublisher.value, placeholder: "Min Fat"))
                    roundedBackground(content: nutritientsSearchView(text: $proteinTextPublisher.value, placeholder: "Min Protein"))
                }
                HStack {
                    roundedBackground(content: nutritientsSearchView(text: $caloriesTextPublisher.value, placeholder: "Min Calories"))
                    roundedBackground(content: nutritientsSearchView(text: $carbsTextPublisher.value, placeholder: "Min Carbs"))
                }
            }
        }
    }
    
    private func nutritientsSearchView(text: Binding<String>, placeholder: String) -> some View {
        TextField(placeholder, text: text)
            .frame(width: .infinity)
            .font(Fonts.makeFont(.regular, size: Constants.FontSizes.medium))
            .foregroundColor(Colors.dark)
            .submitLabel(.search)
            .onSubmit {
                searchRecipes()
            }
            .padding(.horizontal)
    }
    
    private func roundedBackground(content: some View) -> some View {
        RoundedRectangle(cornerRadius: Constants.cornerRadius)
            .foregroundColor(.white)
            .background(Colors.backgroundWhite)
            .cornerRadius(Constants.cornerRadius)
            .frame(width: .infinity, height: searchViewHeight)
            .modifier(LightShadowModifier())
            .overlay {
                content
            }
    }
    
    private func searchRecipes() {
        DispatchQueue.global(qos: .userInteractive).async {
            self.container
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
}
