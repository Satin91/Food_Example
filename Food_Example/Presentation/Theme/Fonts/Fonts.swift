//
//  Fonts.swift
//  Food_Example
//
//  Created by Артур Кулик on 12.01.2023.
//

import SwiftUI

enum Fonts {
    enum Poppins: String {
        case poppins = "Poppins"
        case black = "Poppins-Black"
        case bold = "Poppins-Bold"
        case extraBold = "Poppins-ExtraBold"
        case extraLight = "Poppins-ExtraLight"
        case light = "Poppins-Light"
        case medium = "Poppins-Medium"
        case regular = "Poppins-Regular"
        case semiBold = "Poppins-SemiBold"
        case thin = "Poppins-Thin"
        case dmSans = "DMSans-Bold"
    }
    
    static func makeFont(_ fontName: Poppins, size: CGFloat) -> Font {
        Font.custom(fontName.rawValue, size: size)
    }
}
