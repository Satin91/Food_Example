//
//  SplashScreen.swift
//  Food_Example
//
//  Created by Артур Кулик on 12.01.2023.
//

import SwiftUI

struct SplashScreen: View {
    var body: some View {
        Text("The new NTF")
            .font(
                Fonts.custom(.dmSants,
                size: Constants.FontSizes.upperLarge)
            )
            .foregroundColor(.red)
    }
}

struct SplashScreen_Previews: PreviewProvider {
    static var previews: some View {
        SplashScreen()
    }
}
