//
//  FavoriteRecipesScreen.swift
//  Food_Example
//
//  Created by Артур Кулик on 07.02.2023.
//

import RealmSwift
import SwiftUI

struct FavoriteRecipesScreen: View, TabBarScreen {
    var tabImage: String = Images.icnHomeFilled
    var tabSelectedColor: Color = Colors.green
    @ObservedRealmObject var favoriteObjects: Storage
    
    var body: some View {
        VStack {
            if let firstGroup = favoriteObjects.objects.first {
                Text(firstGroup.title)
                    .foregroundColor(Colors.dark)
                    .font(Fonts.makeFont(.bold, size: Constants.FontSizes.extraLarge))
            } else {
                Text("Empty")
                    .foregroundColor(Colors.dark)
                    .font(Fonts.makeFont(.bold, size: Constants.FontSizes.extraLarge))
                    .onAppear {
                        $favoriteObjects.objects.append(RecipeRealm())
                    }
            }
        }
    }
}

// struct FavoritsRecipesScreen_Previews: PreviewProvider {
//     static var previews: some View {
//         FavoriteRecipesScreen()
//     }
// }
