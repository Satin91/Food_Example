//
//  RecipeScreen.swift
//  Food_Example
//
//  Created by Артур Кулик on 25.01.2023.
//

import SwiftUI

struct RecipeScreen: View {
    @State var recipe: Recipe
    @State var isLoaded = false
    @State var heightImageContainer: CGFloat = 180
    @Environment(\.injected) var container: DIContainer
    
    let onClose: () -> Void
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
            Spacer()
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
            Text(String(recipe.readyInMinutes!) + " min")
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
                .edgesIgnoringSafeArea(.top)
        )
    }
    
    private var nutrientsContainer: some View {
        VStack {
            HStack(spacing: .zero) {
                NutrientView(nutrientType: .carbs(214))
                NutrientView(nutrientType: .protein(244))
            }
            HStack(spacing: .zero) {
                NutrientView(nutrientType: .kcal(125))
                NutrientView(nutrientType: .fats(425))
            }
        }
        .padding(.horizontal, Constants.Spacing.s)
    }
    
    private var titleLabel: some View {
        Text(recipe.title)
            .modifier(LargeNavBarTextModifier())
            .padding(Constants.Spacing.s)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color.white)
    }
    
    private var summaryView: some View {
        ScrollView(.vertical, showsIndicators: false) {
            Text(recipe.summary!)
                .font(Fonts.makeFont(.medium, size: Constants.FontSizes.medium))
                .foregroundColor(Colors.gray)
        }
        .background(Color.white)
    }
    
    private func getRecipeBy(id: Int) {
        container.interactors.recipesInteractor.getRecipeInfoBy(id: id) { recipe in
            self.recipe = recipe
            isLoaded = true
            print(parser.getExcerpt(text: recipe.summary ?? ""))
        }
    }
}

struct RecipeDetailView_Previews: PreviewProvider {
    static var previews: some View {
        //        RecipeScreen(recipe: Recipe(id: 0, title: "", image: ""), onClose: {})
        RecipeScreen(recipe: Recipe(id: 0, title: "", image: ""), onClose: {})
    }
}

struct LoadingView: View {
    var body: some View {
        LottieView(name: Lottie.loader, loopMode: .loop, isStopped: false)
            .frame(width: Constants.loaderLottieSize, height: Constants.loaderLottieSize)
            .toolbar(.hidden)
    }
}
