//
//  RecipeScreen.swift
//  Food_Example
//
//  Created by Артур Кулик on 25.01.2023.
//

import SwiftUI

struct RecipeScreen: View {
    @State var recipe: Recipe
    @Environment(\.injected) var container: DIContainer
    let onClose: () -> Void
    
    var body: some View {
        content
            .toolbar(.hidden)
            .onAppear {
                getRecipeBy(id: recipe.id)
            }
    }
    
    private var content: some View {
        VStack(spacing: .zero) {
            navigationBarView
            Text(recipe.title)
                .foregroundColor(.black)
            Spacer()
        }.background {
            loadableImage
        }
    }
    
    private var navigationBarView: some View {
        NavigationBarView()
            .addLeftContainer {
                Image(Images.icnChevronLeft)
                    .onTapGesture {
                        onClose()
                    }
            }
    }
    
    private var loadableImage: some View {
        VStack {
            LoadableImage(urlString: recipe.image)
                .frame(height: 360)
                .frame(width: .infinity)
            Spacer()
        }
        .ignoresSafeArea(.all)
    }
    
    private func getRecipeBy(id: Int) {
        container.interactors.recipesInteractor.getRecipeInfoBy(id: id) { recipe in
            self.recipe = recipe
        }
    }
}

struct RecipeDetailView_Previews: PreviewProvider {
    static var previews: some View {
        RecipeScreen(recipe: Recipe(id: 0, title: "", image: ""), onClose: {})
    }
}
