//
//  FavoriteRecipesScreen.swift
//  Food_Example
//
//  Created by Артур Кулик on 07.02.2023.
//

import SwiftUI

struct FavoriteRecipesScreen: View, TabBarScreen {
    var tabImage: String = Images.icnHomeFilled
    var tabSelectedColor: Color = Colors.green
    
    var body: some View {
        Text("FavoriteRecipesScreen")
    }
}

struct FavoritsRecipesScreen_Previews: PreviewProvider {
    static var previews: some View {
        FavoriteRecipesScreen()
    }
}
