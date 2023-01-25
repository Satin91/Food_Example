//
//  RecipeScreen.swift
//  Food_Example
//
//  Created by Артур Кулик on 25.01.2023.
//

import SwiftUI

struct RecipeScreen: View {
    let id: Int
    @Environment(\.injected) var container: DIContainer
    @State var recipe = Recipe(id: 0, title: "", image: "")
    let onClose: () -> Void
    
    var body: some View {
        content
            .toolbar(.hidden)
            .onAppear {
                getRecipeBy(id: id)
            }
    }
    
    private var content: some View {
        VStack(spacing: .zero) {
            navigationBarView
            Spacer()
        }
    }
    
    private var recipeImage: some View {
        VStack {
            AsyncImage(
                url: URL(string: recipe.image),
                content: { image in
                    image
                        .resizable()
                        .scaledToFill()
                        .frame(maxHeight: .infinity)
                        .cornerRadius(8)
                        .padding(
                            EdgeInsets(
                                top: Constants.Spacing.xs,
                                leading: Constants.Spacing.xs,
                                bottom: .zero,
                                trailing: Constants.Spacing.xs
                            )
                        )
                }, placeholder: {
                    Image("mockFood")
                        .resizable()
                        .scaledToFill()
                        .foregroundColor(Colors.lightGray)
                        .frame(maxHeight: .infinity)
                }
            )
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
    
    private func getRecipeBy(id: Int) {
        container.interactors.recipesInteractor.getRecipeInfoBy(id: id) { recipe in
            self.recipe = recipe
            container.interactors.imageInteractor.load(path: recipe.image) { image, error in
                guard error == nil else {
                    print("Error load image \( error)")
                    return
                }
                print("Image was loaded \(image)")
            }
        }
    }
}

struct RecipeDetailView_Previews: PreviewProvider {
    static var previews: some View {
        RecipeScreen(id: 0, onClose: {})
    }
}
