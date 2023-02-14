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
    @Environment(\.injected) var container: DIContainer
    
    var body: some View {
        Text(String(container.interactors.recipesInteractor.storage.objects.count))
    }
}

// struct FavoritsRecipesScreen_Previews: PreviewProvider {
//     static var previews: some View {
//         FavoriteRecipesScreen()
//     }
// }
