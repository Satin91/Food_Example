//
//  NavBarTextModifier.swift
//  Food_Example
//
//  Created by Артур Кулик on 18.01.2023.
//

import SwiftUI

struct NavBarTextModifier: ViewModifier {
    let shadowRaduis: CGFloat = 4
    let yOffset: CGFloat = 4
    let opacity: CGFloat = 0.12
    
    func body(content: Content) -> some View {
        content
            .font(Fonts.makeFont(.bold, size: Constants.FontSizes.upperMedium))
            .foregroundColor(Colors.dark)
    }
}

struct LargeNavBarTextModifier: ViewModifier {
    let shadowRaduis: CGFloat = 4
    let yOffset: CGFloat = 4
    let opacity: CGFloat = 0.12
    
    func body(content: Content) -> some View {
        content
            .font(Fonts.makeFont(.bold, size: Constants.FontSizes.large))
            .foregroundColor(Colors.dark)
    }
}
