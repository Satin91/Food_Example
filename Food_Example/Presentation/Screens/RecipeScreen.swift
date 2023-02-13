//
//  RecipeScreen.swift
//  Food_Example
//
//  Created by Артур Кулик on 25.01.2023.
//

import SwiftUI

struct RecipeScreen: View {
    @State var recipe: Recipe
    @State var recipeRealm = RecipeRealm()
    @State var isLoaded = false
    @State var heightImageContainer: CGFloat = 180
    @State var selectedPagingIndex = 0
    @Environment(\.injected) var container: DIContainer
    @State var scrollViewOffest = CGPoint()
    let onClose: () -> Void
    let onShowInstructions: (URL) -> Void
    let parser = HTMLParser()
    
    var body: some View {
        if isLoaded {
            content
                .toolbar(.hidden)
        } else {
            LoadingView()
                .onAppear {
                    getRecipeBy(id: recipe.id)
                }
        }
    }
    
    private var content: some View {
        VStack(spacing: .zero) {
            imageContainer
            titleLabel
            nutrientsContainer
            SegmentedView(selectedIndex: $selectedPagingIndex)
            Divider()
            tabView
        }
        .overlay {
            VStack(spacing: .zero) {
                navigationBarView
                Spacer()
            }
        }
    }
    
    private var navigationBarView: some View {
        NavigationBarView()
            .addLeftContainer {
                Image(Images.icnChevronLeft)
                    .padding(Constants.Spacing.xxs)
                    .background(Colors.backgroundWhite.opacity(0.8))
                    .cornerRadius(Constants.smallCornerRadius)
                    .onTapGesture {
                        onClose()
                    }
            }
    }
    
    private var imageContainer: some View {
        HStack(spacing: Constants.Spacing.xxs) {
            Image(Images.icnClock)
                .renderingMode(.template)
                .foregroundColor(.white)
            Text(String(recipe.readyInMinutes ?? 0) + " min")
                .font(Fonts.makeFont(.semiBold, size: Constants.FontSizes.small))
                .foregroundColor(.white)
        }
        .padding(.vertical, Constants.Spacing.xxxs)
        .padding(.horizontal, Constants.Spacing.xxs)
        .background(Colors.yellow)
        .cornerRadius(Constants.cornerRadius)
        .padding(Constants.Spacing.s)
        .frame(maxWidth: .infinity, maxHeight: heightImageContainer, alignment: .bottomLeading)
        .background(
            LoadableImage(urlString: recipe.image)
                .aspectRatio(contentMode: .fill)
                .edgesIgnoringSafeArea(.top)
        )
    }
    
    private var titleLabel: some View {
        Text(recipeRealm.title)
            .modifier(LargeNavBarTextModifier())
            .padding(Constants.Spacing.s)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color.white)
    }
    
    private var nutrientsContainer: some View {
        VStack {
            HStack(spacing: .zero) {
                NutrientView(nutrientType: .carbs(recipe.nutrients?.carbs ?? ""))
                NutrientView(nutrientType: .protein(recipe.nutrients?.protein ?? ""))
            }
            HStack(spacing: .zero) {
                NutrientView(nutrientType: .kcal(recipe.nutrients?.calories ?? ""))
                NutrientView(nutrientType: .fats(recipe.nutrients?.fat ?? ""))
            }
        }
        .padding(.horizontal, Constants.Spacing.s)
    }
    
    private var tabView: some View {
        TabView(selection: $selectedPagingIndex) {
            ingredientView
                .tag(0)
            summaryView
                .tag(1)
            instructionsView
                .tag(2)
        }
        .tabViewStyle(.page)
        .ignoresSafeArea(.all)
        .animation(.easeInOut(duration: 0.2), value: selectedPagingIndex)
        .transition(.slide)
    }
    
    //    private var nutrutientsMockContainer: some View {
    //        VStack {
    //            HStack(spacing: .zero) {
    //                NutrientView(nutrientType: .carbs("126g carbs"))
    //                NutrientView(nutrientType: .protein("450g protein"))
    //            }
    //            HStack(spacing: .zero) {
    //                NutrientView(nutrientType: .kcal("624k colories"))
    //                NutrientView(nutrientType: .fats("160g fat"))
    //            }
    //        }
    //        .padding(.horizontal, Constants.Spacing.s)
    //    }
    
    private var ingredientView: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack {
                ForEach(recipe.ingridients ?? [], id: \.self) { ingredient in
                    IngredientView(ingredient: ingredient)
                        .padding()
                        .frame(height: 90)
                        .ignoresSafeArea(.all)
                }
            }
        }
    }
    
    @ViewBuilder var summaryView: some View {
        ScrollView(.vertical) {
            HTMLTextView(text: recipe.summary ?? "Summary not available")
                .padding(Constants.Spacing.s)
        }
    }
    
    @ViewBuilder private var instructionsView: some View {
        GeometryReader { proxy in
            ZStack {
                Image(Images.foodBackground)
                    .resizable()
                    .scaledToFill()
                VStack {
                    Spacer()
                    HStack {
                        Button {
                            if let url = URL(string: recipe.sourceUrl ?? "") {
                                DispatchQueue.main.async {
                                    self.onShowInstructions(url)
                                }
                            }
                        } label: {
                            Text("Read the detailed instructions")
                            Image(systemName: "link")
                        }
                    }
                    .foregroundColor(Colors.blue)
                    .padding(.bottom, Constants.Spacing.xxxl)
                }
            }
            .ignoresSafeArea()
            .frame(width: proxy.size.width)
            .frame(height: proxy.size.height)
        }
    }
    
    private func getRecipeBy(id: Int) {
        guard isLoaded == false else { return }
        DispatchQueue.global(qos: .unspecified).async {
            container.interactors.recipesInteractor.getRecipeInfoBy(id: id) { result in
                switch result {
                case .success(let recipe):
                    self.recipeRealm = .init(recipe: recipe)
                    print(recipeRealm.extendedIngredients)
                    self.recipe = recipe
                    self.isLoaded = true
                case .failure(let error):
                    print(error)
                }
            }
        }
    }
}

struct RecipeDetailView_Previews: PreviewProvider {
    static var previews: some View {
        RecipeScreen(recipe: Recipe(id: 0, title: "", image: ""), onClose: {}, onShowInstructions: { _ in })
    }
}

extension Text {
    init(_ string: String, configure: ((inout AttributedString) -> Void)) {
        var attributedString = AttributedString(string)
        configure(&attributedString)
        self.init(attributedString)
    }
}
