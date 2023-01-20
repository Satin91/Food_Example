//
//  ContentView.swift
//  Food_Example
//
//  Created by Артур Кулик on 11.01.2023.
//

import FirebaseAuth
import SwiftUI

struct MainScreen: View {
    @ObservedObject var viewModel = MainViewModel()
    @State var recipes: [Recipe] = []
    @State var isAnimate = false
    @State var searchText: String = ""
    let searchViewSize = CGSize(width: 40, height: 40)
    let searchButtonBackground = Colors.border
    
    let columns = [
        GridItem(.flexible(), spacing: 0),
        GridItem(.flexible(), spacing: 0)
    ]
    @State var gridWidth: CGFloat = 0
    
    var body: some View {
        content
            .toolbar(.hidden)
    }
    
    private var content: some View {
        VStack(spacing: Constants.Spacing.zero) {
            NavigationBarView()
                .addLeftContainer {
                    Text("Most popular recipes")
                        .modifier(LargeNavBarTextModifier())
                        .opacity(isAnimate ? 0 : 1)
                        .animation(.easeInOut(duration: 0.1), value: isAnimate)
                }
                .addRightContainer {
                    searchView
                }
                .padding(.vertical)
            Divider()
            ScrollView(.vertical) {
                recipesList(viewModel.recipes)
            }
        }
    }
    
    private var searchView: some View {
        ZStack {
            RoundedRectangle(cornerRadius: Constants.cornerRadius)
                .stroke(isAnimate ? Colors.lightGray : .clear, lineWidth: 1)
                .background(isAnimate ? Colors.backgroundWhite : Colors.border)
                .cornerRadius(Constants.cornerRadius)
                .frame(width: isAnimate ? .infinity : searchViewSize.width, height: searchViewSize.height)
            HStack(spacing: Constants.Spacing.xxs) {
                Image(Images.icnSearch)
                    .padding(.leading, isAnimate ? Constants.Spacing.xxs : Constants.Spacing.zero)
                    .onTapGesture {
                        animateSearchView()
                    }
                if isAnimate {
                    TextField("Search by ingridients", text: $searchText)
                        .frame(width: .infinity)
                        .font(Fonts.custom(.regular, size: Constants.FontSizes.medium))
                        .foregroundColor(Colors.dark)
                        .submitLabel(.search)
                        .onSubmit {
                            isAnimate.toggle()
                        }
                }
            }
        }
        .animation(.easeInOut, value: isAnimate)
    }
    
    private func recipesList(_ recipes: [Recipe]) -> some View {
        LazyVGrid(columns: columns, spacing: 0) {
            ForEach(recipes) { recipe in
                RecipeGrid(
                    recipe: recipe,
                    action: {
                        print("Action")
                    }, settingsAction: {
                        print("Settings Action")
                    }
                )
                .padding(Constants.Spacing.xs)
            }
        }
        .task {
            await viewModel.showRandomRecipes()
        }
    }
    
    func animateSearchView() {
        isAnimate.toggle()
    }
}
