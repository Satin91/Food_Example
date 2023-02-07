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
    @State private var allCategoriesTextPublisher = CurrentValueSubject<String, Never>("")
    @State private var ingridientsTextPublisher = CurrentValueSubject<String, Never>("")
    @State private var fatTextPublisher = CurrentValueSubject<String, Never>("")
    @State private var proteinTextPublisher = CurrentValueSubject<String, Never>("")
    @State private var caloriesTextPublisher = CurrentValueSubject<String, Never>("")
    @State private var carbsTextPublisher = CurrentValueSubject<String, Never>("")
    @State private var currentSearchCategory: APIEndpoint = .searchInAll
    @State private var searchParams: [String: String] = [:]
    @State private var cancelBag = Set<AnyCancellable>()
    @State private var recipes: [Recipe] = []
    
    let searchViewHeight: CGFloat = 56
    let searchButtonBackground = Colors.neutralGray
    let onShowRecipeScreen: (_ id: Recipe) -> Void
    
    let columns = [
        GridItem(.flexible(), spacing: .zero),
        GridItem(.flexible(), spacing: .zero)
    ]
    @State var gridWidth: CGFloat = 0
    
    var body: some View {
        content
            .toolbar(.hidden)
            .onAppear {
                addFilterObservers()
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
                    .foregroundColor(Colors.dark)
                Spacer()
                HStack {
                    clearFilterButton
                    filterMenu
                }
            }
            Text("What do you want to cook?")
                .font(Fonts.makeFont(.regular, size: Constants.FontSizes.extraMedium))
                .foregroundColor(Colors.gray)
            searchView
                .padding(.vertical)
        }
    }
    
    @ViewBuilder private var searchView: some View {
        if currentSearchCategory == .searchByNutritients {
            nutritientsFilterContainer
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
            TextField(currentSearchCategory.text, text: currentSearchCategory == .searchInAll ? $allCategoriesTextPublisher.value : $ingridientsTextPublisher.value)
                .frame(width: .infinity)
                .font(Fonts.makeFont(.regular, size: Constants.FontSizes.medium))
                .foregroundColor(Colors.dark)
                .submitLabel(.search)
                .onSubmit {
                    searchRecipes()
                }
        }
    }
    
    private var filterMenu: some View {
        Menu {
            Button("Search in all categories") {
                currentSearchCategory = .searchInAll
            }
            Button("Search by igredients") {
                currentSearchCategory = .searchByIngridient
            }
            Button("Search by nutritients") {
                currentSearchCategory = .searchByNutritients
            }
        } label: {
            Image(Images.icnFilter)
                .renderingMode(.template)
                .resizable()
                .foregroundColor(Colors.gray)
                .frame(width: 30, height: 30)
        }
    }
    
    private var clearFilterButton: some View {
        Image(Images.icnClose)
            .renderingMode(.template)
            .resizable()
            .foregroundColor(Colors.red)
            .opacity(searchParams.isEmpty ? 0 : 1)
            .frame(width: 30, height: 30)
            .onTapGesture {
                clearFilter()
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
            }
        }
    }
    
    private var nutritientsFilterContainer: some View {
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
    
    private func addFilterObservers() {
        allCategoriesTextPublisher
            .sink { searchParams.safely(key: "query", value: $0) }
            .store(in: &cancelBag)
        ingridientsTextPublisher
            .sink { searchParams.safely(key: "ingredients", value: $0) }
            .store(in: &cancelBag)
        carbsTextPublisher
            .sink { searchParams.safely(key: "minCarbs", value: $0.containsRange(min: 1, max: 100)) }
            .store(in: &cancelBag)
        proteinTextPublisher
            .sink { searchParams.safely(key: "minProtein", value: $0.containsRange(min: 10, max: 100)) }
            .store(in: &cancelBag)
        caloriesTextPublisher
            .sink { searchParams.safely(key: "minCalories", value: $0.containsRange(min: 50, max: 800)) }
            .store(in: &cancelBag)
        fatTextPublisher
            .sink { searchParams.safely(key: "minFat", value: $0.containsRange(min: 1, max: 100)) }
            .store(in: &cancelBag)
    }
    
    private func clearFilter() {
        allCategoriesTextPublisher.send("")
        ingridientsTextPublisher.send("")
        fatTextPublisher.send("")
        proteinTextPublisher.send("")
        caloriesTextPublisher.send("")
        carbsTextPublisher.send("")
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
                        DispatchQueue.main.async {
                            self.recipes = recipes
                        }
                    }
                )
        }
    }
}
