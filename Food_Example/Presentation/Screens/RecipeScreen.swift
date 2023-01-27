//
//  RecipeScreen.swift
//  Food_Example
//
//  Created by Артур Кулик on 25.01.2023.
//

import SwiftUI

struct RecipeScreen: View {
    //    @State var recipe: Recipe
    let recipe = RecipeMock()
    @Environment(\.injected) var container: DIContainer
    let onClose: () -> Void
    @State var isLoaded = false
    @State var heightImageContainer: CGFloat = 180
    var body: some View {
        if isLoaded {
            content
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
            titleContainer
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
                    .cornerRadius(8)
                    .onTapGesture {
                        onClose()
                    }
            }
    }
    
    private var imageContainer: some View {
        //            LoadableImage(urlString: recipe.image)
        HStack(spacing: Constants.Spacing.xxs) {
            Image(Images.icnClock)
                .renderingMode(.template)
                .foregroundColor(.white)
            Text(String(recipe.readyInMinutes) + " min")
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
            Image(recipe.image)
                .resizable()
                .scaledToFill()
                .edgesIgnoringSafeArea(.top)
        )
    }
    
    @ViewBuilder private var titleContainer: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(spacing: .zero) {
                Text(recipe.title)
                    .modifier(LargeNavBarTextModifier())
                    .padding(.vertical, Constants.Spacing.s)
                Text(recipe.summary)
                    .font(Fonts.makeFont(.regular, size: Constants.FontSizes.medium))
            }
            .multilineTextAlignment(.leading)
        }
        .padding(.horizontal, Constants.Spacing.s)
        .background(Color.white)
    }
    
    private func getRecipeBy(id: Int) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            isLoaded = true
        }
        //        container.interactors.recipesInteractor.getRecipeInfoBy(id: id) { recipe in
        //            self.recipe = recipe
        //        }
    }
}

struct RecipeDetailView_Previews: PreviewProvider {
    static var previews: some View {
        //        RecipeScreen(recipe: Recipe(id: 0, title: "", image: ""), onClose: {})
        RecipeScreen {
        }
    }
}

struct LoadingView: View {
    var body: some View {
        LottieView(name: Lottie.loader, loopMode: .loop, isStopped: false)
            .frame(width: Constants.loaderLottieSize, height: Constants.loaderLottieSize)
            .toolbar(.hidden)
    }
}
