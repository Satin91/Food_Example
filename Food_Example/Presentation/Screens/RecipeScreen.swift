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
    @State var selectedPagingIndex = 0
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
            //            nutrutientsMockContainer
            nutrientsContainer
            SegmentedView(selectedIndex: $selectedPagingIndex)
            ingredientView
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
        Text(recipe.title)
            .modifier(LargeNavBarTextModifier())
            .padding(Constants.Spacing.s)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color.white)
    }
    
    private var nutrientsContainer: some View {
        VStack {
            HStack(spacing: .zero) {
                NutrientView(nutrientType: .carbs(recipe.nutrients!.carbs))
                NutrientView(nutrientType: .protein(recipe.nutrients!.protein))
            }
            HStack(spacing: .zero) {
                NutrientView(nutrientType: .kcal(recipe.nutrients!.calories))
                NutrientView(nutrientType: .fats(recipe.nutrients!.fat))
            }
        }
        .padding(.horizontal, Constants.Spacing.s)
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
                        .frame(height: 80)
                }
            }
        }
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
        DispatchQueue.global(qos: .unspecified).async {
            container.interactors.recipesInteractor.getRecipeInfoBy(id: id) { result in
                switch result {
                case .success(let recipe):
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

struct SegmentedView: View {
    /* The itemSizes property stores the width of the text.
    It is needed so that the underline matches the width of the text.
    */
    @State var itemSizes: [Int: CGFloat] = [:] {
        didSet {
            print(itemSizes)
        }
    }
    @Binding var selectedIndex: Int
    
    var body: some View {
        content
    }
    
    private var content: some View {
        VStack(spacing: Constants.Spacing.xxxs) {
            segmentedView
            underline
        }
        .padding(Constants.Spacing.s)
    }
    
    // If the SegmentedView needs to be reused, changes will be made to the initializer and rendering will happen automatically, now this is not required.
    var segmentedView: some View {
        HStack(spacing: .zero) {
            SegmentedItem(index: 0, title: "Ingridients", selectedIndex: $selectedIndex) { width in
                itemSizes[0] = width
            }
            SegmentedItem(index: 1, title: "Summary", selectedIndex: $selectedIndex) { width in
                itemSizes[1] = width
            }
            SegmentedItem(index: 2, title: "Instructions", selectedIndex: $selectedIndex) { width in
                itemSizes[2] = width
            }
        }
    }
    private var underline: some View {
        HStack(spacing: .zero) {
            if selectedIndex == 2 {
                spacers
            }
            Rectangle()
                .foregroundColor(Color.clear)
                .background {
                    Rectangle()
                        .frame(width: itemSizes[selectedIndex])
                        .cornerRadius(2)
                        .foregroundColor(Colors.red)
                }
                .frame(height: 4)
            if selectedIndex == 0 {
                spacers
            }
        }
        .animation(.easeOut(duration: 0.2), value: selectedIndex)
    }
    
    /* Two spacers are needed to evenly distribute the space so that the underline is in the center of any of the three elements of the HStack
    */
    private var spacers: some View {
        Group {
            Spacer()
            Spacer()
        }
        .frame(maxWidth: .infinity)
    }
}

struct SegmentedItem: View {
    let index: Int
    let title: String
    @Binding var selectedIndex: Int
    let textWidth: (CGFloat) -> Void
    var isSelected: Bool {
        index == selectedIndex
    }
    
    var body: some View {
        content
            .onTapGesture {
                selectedIndex = index
            }
    }
    
    var content: some View {
        Text(title)
            .font(Fonts.makeFont(.medium, size: Constants.FontSizes.medium))
            .foregroundColor(isSelected ? Colors.dark : Colors.weakGray)
            .readSize { size in
                textWidth(size.width)
            }
            .frame(maxWidth: .infinity)
    }
}
